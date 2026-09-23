data "google_compute_network" "vpc-network" {
  name    = var.network
  project = var.project_id
}

data "google_compute_subnetwork" "subnetwork" {
  project   = var.project_id
  for_each  = toset(data.google_compute_network.vpc-network.subnetworks_self_links)
  self_link = each.value
  depends_on = [
    data.google_compute_network.vpc-network
  ]
}
