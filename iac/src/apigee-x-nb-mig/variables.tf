# Declaration of variables used across the modules and resources

# Module :: Project
variable "project_id" {
  description = "Project id (also used for the Apigee Organization)."
  type        = string
}

variable "project_parent" {
  description = "Parent folder or organization in 'folders/folder_id' or 'organizations/org_id' format."
  type        = string
  default     = null
  validation {
    condition     = var.project_parent == null || can(regex("(organizations|folders)/[0-9]+", var.project_parent))
    error_message = "Parent must be of the form folders/folder_id or organizations/organization_id."
  }
}

variable "project_create" {
  description = "Create project. When set to false, uses a data source to reference existing project."
  type        = bool
  default     = false
}

variable "billing_account" {
  description = "Billing account id."
  type        = string
  default     = null
}

variable "services" {
  description = "Service APIs to enable."
  type        = list(string)
  default     = []
}

# Module :: VPC
variable "network" {
  description = "VPC name."
  type        = string
}

variable "vpc_host_project_id" {
  description = "VPC Host Project ID"
  type        = string
}

variable "vpc_create" {
  description = "Create VPC. When set to false, uses a data source to reference existing VPC."
  type        = bool
  default     = false
}

variable "peering_range" {
  description = "Peering CIDR range"
  type        = string
}

variable "support_range" {
  description = "Support CIDR range of length /28 (required by Apigee for troubleshooting purposes)."
  type        = string
}

variable "apigee_subnet" {
  description = "Name of Subnet created for APIGEE bridge"
  type        = string
}

# Module :: apigee-x-core

variable "ax_region" {
  description = "GCP region for storing Apigee analytics data (see https://cloud.google.com/apigee/docs/api-platform/get-started/install-cli)."
  type        = string
}

variable "apigee_instances" {
  description = "Apigee Instances List"
  type = map(object({
    region       = string
    environments = list(string)
  }))
  default = {}
}

variable "apigee_environments" {
  description = "Apigee Environment Names."
  type        = list(string)
  default     = []
}

variable "apigee_envgroups" {
  description = "Apigee Environment Groups."
  type = map(object({
    environments = list(string)
    hostnames    = list(string)
  }))
  default = {}
}

variable "apigee_org_kms_keyring_name" {
  description = "Name of the KMS Key Ring for Apigee Organization DB."
  type        = string
  default     = "apigee-x-org-db"
}

variable "apigee_inst_kms_keyring_name_prefix" {
  description = "Prefix for the KMS Key Ring name for Apigee X Instance. This will be appended with the region name for the instance"
  type        = string
  default     = "apigee-x"
}


# Module :: Managed Instance Groups
variable "mig_name" {
  description = "Name for the Managed Instance Group. This will be used for the template, service accounts associated. There is a length limitation defined, 6-30 characters as min-max respectively"
  type        = string
  default     = "apigee-mig"
}

variable "mig_network_tags" {
  description = "Network tags for the Bridge VMs."
  type        = list(string)
  default     = ["apigee-bridge"]
}

variable "mig_machine_type" {
  description = "GCE Machine type."
  type        = string
  default     = "e2-small"
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
  type        = number
  default     = 20
}

variable "mig_target_size" {
  description = "No of Managed Instances to be created"
  type        = number
  default     = 2
}

variable "autoscaler_config" {
  description = "Optional autoscaler configuration. Only one of 'cpu_utilization_target' 'load_balancing_utilization_target' or 'metric' can be not null."
  type = object({
    max_replicas                      = number
    min_replicas                      = number
    cooldown_period                   = number
    cpu_utilization_target            = number
    load_balancing_utilization_target = number
    metric = object({
      name                       = string
      single_instance_assignment = number
      target                     = number
      type                       = string # GAUGE, DELTA_PER_SECOND, DELTA_PER_MINUTE
      filter                     = string
    })
  })
  default = null
}

variable "mig_startup_script" {
  description = "Storage location for the startup script needed for MIG Instances pointing to APIGEE"
  type        = string
  default     = "gs://apigee-5g-saas/apigee-envoy-proxy-release/latest/conf/startup-script-envoy.sh"
}

variable "mig_create_service_account" {
  description = "value"
  type        = bool
  default     = true
}

variable "mig_ssh_source_range" {
  description = "Source range to allow ssh into compute instances"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Module :: Load Balancer
variable "loadbalancer_name" {
  description = "Name for the HTTPS Load Balancer."
  type        = string
  default     = "apigee-xlb"
}

variable "lb_external_ip" {
  description = "External IP for the L7 XLB."
  type        = string
  default     = null
}

variable "lb_cert_cn" {
  description = "CN for the temporary certificate"
  type        = string
  default     = "temp-cert"
}

variable "lb_cert_org" {
  description = "Org name for the temporary certificate"
  type        = string
  default     = "DummyOrg"
}

variable "lb_cert_domain" {
  description = "Domains for the temporary certificate"
  type        = list(string)
  default     = ["dummyorg.com"]
}

variable "lb_cert_validity" {
  description = "Temporary certificate validity in hours"
  type        = number
  default     = 24
}

variable "lb_log_enable" {
  description = "Enable Logging for LB backend service"
  type        = bool
  default     = true
}

variable "lb_log_samplerate" {
  description = "Sampling rate of requests. 1.0 means all logged requests are reported, 0.0 means no logged requests are reported"
  type        = number
  default     = 1.0
}

variable "lb_outbound_range" {
  description = "Source range to allow ssh into compute instances"
  type        = list(string)
  default     = ["130.211.0.0/22", "35.191.0.0/16"]
}
