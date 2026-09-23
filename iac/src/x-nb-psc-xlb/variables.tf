/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  description = "Project id (also used for the Apigee Organization)."
  type        = string
}

variable "billing_type" {
  description = "Billing type of the Apigee organization."
  type        = string
  default     = null
}

variable "ax_region" {
  description = "GCP region for storing Apigee analytics data (see https://cloud.google.com/apigee/docs/api-platform/get-started/install-cli)."
  type        = string
}

variable "apigee_environments" {
  description = "Apigee Environments."
  type = map(object({
    display_name = optional(string)
    description  = optional(string, "Terraform-managed")
    node_config = optional(object({
      min_node_count = optional(number)
      max_node_count = optional(number)
    }))
    iam       = optional(map(list(string)))
    type      = optional(string)
    envgroups = list(string)
  }))
  default = null
}

variable "apigee_instances" {
  description = "Apigee Instances (only one instance for EVAL)."
  type = map(object({
    region               = string
    ip_range             = optional(string, null)
    environments         = list(string)
    keyring_create       = optional(bool, true)
    keyring_name         = optional(string, null)
    keyring_location     = optional(string, null)
    key_name             = optional(string, "inst-disk")
    key_rotation_period  = optional(string, "2592000s")
    key_labels           = optional(map(string), null)
    consumer_accept_list = optional(list(string), null)
  }))
  default = {}
}

variable "addons_config" {
  description = "Addons configuration."
  type = object({
    advanced_api_ops    = optional(bool, false)
    api_security        = optional(bool, false)
    connectors_platform = optional(bool, false)
    integration         = optional(bool, false)
    monetization        = optional(bool, false)
  })
  default = null
}

variable "apigee_envgroups" {
  description = "Apigee Environment Groups."
  type = map(object({
    environments = list(string)
    hostnames    = list(string)
  }))
  default = {}
}

variable "network" {
  description = "VPC name."
  type        = string
}

variable "peering_range" {
  description = "Peering CIDR range"
  type        = string
}

variable "support_range" {
  description = "Support CIDR range of length /28 (required by Apigee for troubleshooting purposes)."
  type        = string
}

variable "psa_config_export_routes" {
  description = "Export routes in Service Network Peering connection"
  type        = bool
  default     = false
}

variable "billing_account" {
  description = "Billing account id."
  type        = string
  default     = null
}

variable "apigee_org_kms_keyring_name" {
  description = "Name of the KMS Key Ring for Apigee Organization DB."
  type        = string
  default     = "apigee-x-org"
}

variable "apigee_inst_kms_keyring_name_prefix" {
  description = "Prefix for the KMS Key Ring name for Apigee X Instance. This will be appended with the region name for the instance"
  type        = string
  default     = "apigee-x"
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

variable "psc_ingress_network" {
  description = "PSC ingress VPC name."
  type        = string
}

variable "psc_ingress_subnets" {
  description = "Subnets for exposing Apigee services via PSC"
  type = list(object({
    name               = string
    ip_cidr_range      = string
    region             = string
    secondary_ip_range = map(string)
  }))
  default = []
}

variable "retention" {
  description = "Optional. It controls how long Organization data will be retained after the initial delete operation completes. During this period, the Organization may be restored to its last known state. After this period, the Organization will no longer be able to be restored. Default value is DELETION_RETENTION_UNSPECIFIED (retains data for 7 days), Other accepted value : MINIMUM"
  type        = string
  default     = "DELETION_RETENTION_UNSPECIFIED"
}

variable "loadbalancer_name" {
  description = "Name for the HTTPS Load Balancer."
  type        = string
  default     = "apigee-xlb"
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

variable "lb_hostnames" {
  description = "FQDN for LB"
  type        = list(string)
}

variable "lb_certificate_prefix" {
  description = "A prefix string for certificate name for the HTTPS LB."
  type        = string
}