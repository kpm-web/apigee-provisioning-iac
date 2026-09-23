data "google_compute_region_network_endpoint_group" "psc_neg_backends" {
  project  = var.project_id
  for_each = var.apigee_instances
  name     = "psc-neg-${each.value.region}"
  region   = each.value.region
}

resource "google_compute_global_address" "external_address" {
  project      = var.project_id
  name         = "${var.name}-external"
  address_type = "EXTERNAL"
}

locals {
  hostname        = "${replace(google_compute_global_address.external_address.address, ".", "-")}.nip.io"
  subdomains      = [for subdomain in var.hostnames : "${subdomain}-${local.hostname}"]
  certname        = "cert-${replace(google_compute_global_address.external_address.address, ".", "")}"
  managed_domains = concat([local.hostname], local.subdomains)
  # managed_domains = var.hostnames
}

resource "random_id" "certificate" {
  byte_length = 2
  prefix      = var.certificate_prefix

  keepers = {
    domains = join(",", local.managed_domains)
  }
}

resource "google_compute_managed_ssl_certificate" "google_cert" {
  project = var.project_id
  name    = random_id.certificate.hex
  # name    = "${random_id.certificate.hex}-${replace(tolist(var.hostnames)[0], ".", "")}"
  managed {
    domains = local.managed_domains
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_ssl_policy" "loadbalancer-ssl-policy" {
  project         = var.project_id
  name            = "${var.name}-ssl-policy"
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"
}

resource "google_compute_health_check" "psc_backend_hc" {
  project = var.project_id
  name    = "${var.name}-hc"
  https_health_check {
    port         = "443"
    request_path = "/healthz/ingress"
  }
}

# Default resources
resource "google_compute_backend_service" "psc_backend" {
  project               = var.project_id
  name                  = "${var.name}-backend"
  port_name             = "https"
  protocol              = "HTTPS"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  security_policy       = var.security_policy
  edge_security_policy  = var.edge_security_policy
  dynamic "backend" {
    for_each = [for neg in values(data.google_compute_region_network_endpoint_group.psc_neg_backends) : neg.id]
    content {
      group = backend.value
    }
  }
  log_config {
    enable      = var.log_enable
    sample_rate = var.log_samplerate
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_url_map" "url_map" {
  project         = var.project_id
  name            = var.name
  default_service = google_compute_backend_service.psc_backend.id
}

resource "google_compute_target_https_proxy" "https_proxy" {
  project = var.project_id
  name    = "${var.name}-https-proxy"
  url_map = google_compute_url_map.url_map.id
  # ssl_certificates = var.ssl_certificate
  ssl_certificates = [google_compute_managed_ssl_certificate.google_cert.id
  ]
  ssl_policy = google_compute_ssl_policy.loadbalancer-ssl-policy.id
  depends_on = [
    google_compute_url_map.url_map,
    google_compute_managed_ssl_certificate.google_cert,
    google_compute_ssl_policy.loadbalancer-ssl-policy
  ]
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  project               = var.project_id
  name                  = "${var.name}-forwarding-rule"
  target                = google_compute_target_https_proxy.https_proxy.id
  ip_address            = google_compute_global_address.external_address.address
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  labels                = var.labels
}