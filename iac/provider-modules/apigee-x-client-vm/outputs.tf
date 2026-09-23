output "template_name" {
  description = "Compute Instance Template Name"
  value       = module.vm-template.template_name
}

output "template" {
  description = "Compute Instance Template Resource"
  value       = module.vm-template.template
}

output "client_vm" {
  description = "Self Link for Client VM created"
  value       = google_compute_instance_from_template.client-vm.self_link
}
