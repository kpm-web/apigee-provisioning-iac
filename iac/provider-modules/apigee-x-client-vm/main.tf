locals {
  template_name = var.vm_name == null ? "apigee-client" : var.vm_name
}

module "vm-template" {
  source        = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/compute-vm?ref=v58.0.0"
  project_id    = var.project_id
  name          = local.template_name
  zone          = "${var.region}-b"
  tags          = var.network_tags
  instance_type = var.machine_type
  network_interfaces = [{
    network    = var.network,
    subnetwork = var.subnet
    nat        = false
    addresses  = null
    alias_ips  = null
  }]
  boot_disk = {
    image = var.boot_disk_image
    type  = var.image_type
    size  = var.disk_size
  }
  create_template        = {}
  service_account_create = var.create_service_account
  service_account_scopes = ["cloud-platform"]
}

resource "google_compute_instance_from_template" "client-vm" {
  project                  = var.project_id
  name                     = "${local.template_name}-vm"
  zone                     = "${var.region}-a"
  source_instance_template = module.vm-template.template.self_link
}

resource "google_compute_firewall" "ssh-rule" {
  project = var.vpc_host_project_id
  name    = "allow-compute-ssh"
  network = var.network
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags   = var.network_tags
  source_ranges = var.ssh_source_range
}
