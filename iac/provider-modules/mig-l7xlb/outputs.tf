output "lb_ip" {
  depends_on = [
    google_compute_global_address.external_address
  ]
  description = "Load Balancer IP address"
  value       = google_compute_global_address.external_address.address
}

output "certificate_self_link" {
  depends_on = [
    google_compute_ssl_certificate.mig_lb_cert
  ]
  description = "Self Link for SSL Certificate generated or uploaded"
  value       = google_compute_ssl_certificate.mig_lb_cert.self_link
}
