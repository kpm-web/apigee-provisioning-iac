output "vpc_id" {
  description = "VPC Network ID"
  value       = data.google_compute_network.vpc-network.id
}

output "vpc_self_link" {
  description = "VPC Network Self Link"
  value       = data.google_compute_network.vpc-network.self_link
}

output "subnetworks_self_links" {
  description = "List of Subnets' self links"
  value       = data.google_compute_network.vpc-network.subnetworks_self_links
}

output "subnet_name" {
  description = "List of Subnet names"
  value       = [for subnet in data.google_compute_subnetwork.subnetwork : subnet.name]
}

output "apigee_subnet_selflink" {
  description = "Self link for the VPC subnet"
  value       = [for link in data.google_compute_network.vpc-network.subnetworks_self_links : link if length(regexall(var.apigee_subnet, link)) > 0]
}

