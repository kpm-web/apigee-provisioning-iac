output "psc_neg_backends" {
  # The `values()` function converts the map into a list of objects.
  # The `for` expression then extracts the `name` attribute from each object,
  # creating a flat list of names.
  value = [for neg in values(data.google_compute_region_network_endpoint_group.psc_neg_backends) : neg.id]
}

output "ssl_certificate" {
  description = "Google-managed SSL certificate"
  value       = google_compute_managed_ssl_certificate.google_cert.id
}

output "ip_address" {
  description = "Reserved external IP address."
  value       = google_compute_global_address.external_address.address
}