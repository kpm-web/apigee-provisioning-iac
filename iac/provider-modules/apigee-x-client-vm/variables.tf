variable "vm_name" {
  description = "Name of the Compute VM Instance to be created"
  type        = string
  default     = "null"
}

variable "project_id" {
  description = "GCP Project id."
  type        = string
}

variable "network_tags" {
  description = "Network tags for the Client VMs."
  type        = list(string)
  default     = ["apigee-clients"]
}

variable "region" {
  description = "GCP Region for the VMs."
  type        = string
}

variable "machine_type" {
  description = "GCE Machine type."
  type        = string
  default     = "e2-small"
}

variable "network" {
  description = "VPC network for running the VMs (needs to be peered with the Apigee tenant project)."
  type        = string
}

variable "subnet" {
  description = "VPC subnet self link for running the VMs"
  type        = string
}

variable "boot_disk_image" {
  description = "Image source for the Boot Disk"
  type        = string
}

variable "image_type" {
  description = "Image Type"
  type        = string
}

variable "disk_size" {
  description = "Disk Size"
  type        = string
  default     = "20"
}

variable "create_service_account" {
  description = "value"
  type        = bool
  default     = true
}

variable "vpc_host_project_id" {
  description = "VPC Host Project ID"
  type        = string
}

variable "ssh_source_range" {
  description = "Source range to allow ssh into compute instances"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
