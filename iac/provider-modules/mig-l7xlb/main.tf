
resource "google_compute_global_address" "external_address" {
  project      = var.project_id
  name         = "${var.name}-external"
  address_type = "EXTERNAL"
}

resource "google_compute_ssl_policy" "loadbalancer-ssl-policy" {
  project         = var.project_id
  name            = "${var.name}-ssl-policy"
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"
}

# Generate temp self signed certs for the Load Balancer. This will have to be replaced with CA signed using gcloud commands.
resource "tls_private_key" "apigee_lb" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "apigee_lb" {
  private_key_pem = tls_private_key.apigee_lb.private_key_pem

  # Certificate expires after 12 hours.
  validity_period_hours = var.cert_validity

  # Generate a new certificate if Terraform is run within three
  # hours of the certificate's expiration time.
  early_renewal_hours = 3

  # Reasonable set of uses for a server SSL certificate.
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  dns_names = var.cert_domain

  subject {
    common_name  = var.cert_cn
    organization = var.cert_org
  }
}

# Added this SSL certificate resource to read unmanaged / self managed certificate.
resource "google_compute_ssl_certificate" "mig_lb_cert" {
  project     = var.project_id
  name_prefix = "${var.name}-cert-"
  private_key = tls_private_key.apigee_lb.private_key_pem
  certificate = tls_self_signed_cert.apigee_lb.cert_pem

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_health_check" "mig_lb_hc" {
  project = var.project_id
  name    = "${var.name}-hc"
  https_health_check {
    port         = "443"
    request_path = "/healthz/ingress"
  }
}

resource "google_compute_backend_service" "mig_backend" {
  project       = var.project_id
  name          = "${var.name}-backend"
  port_name     = "https"
  protocol      = "HTTPS"
  timeout_sec   = 10
  health_checks = [google_compute_health_check.mig_lb_hc.id]
  dynamic "backend" {
    for_each = var.backend_migs
    content {
      group = backend.value
    }
  }
  log_config {
    enable      = var.log_enable
    sample_rate = var.log_samplerate
  }
}

resource "google_compute_url_map" "url_map" {
  project         = var.project_id
  name            = var.name
  default_service = google_compute_backend_service.mig_backend.id
}

resource "google_compute_target_https_proxy" "https_proxy" {
  project          = var.project_id
  name             = "${var.name}-target-proxy"
  url_map          = google_compute_url_map.url_map.id
  ssl_certificates = [google_compute_ssl_certificate.mig_lb_cert.id]
  ssl_policy       = google_compute_ssl_policy.loadbalancer-ssl-policy.id
  depends_on = [
    google_compute_url_map.url_map,
    google_compute_ssl_certificate.mig_lb_cert,
    google_compute_ssl_policy.loadbalancer-ssl-policy
  ]
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  project    = var.project_id
  name       = "${var.name}-forwarding-rule"
  target     = google_compute_target_https_proxy.https_proxy.id
  ip_address = google_compute_global_address.external_address.address
  port_range = "443"
}

