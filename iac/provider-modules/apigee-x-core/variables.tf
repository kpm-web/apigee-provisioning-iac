/**
 * Copyright 2021 Google LLC
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

variable "org_display_name" {
  description = "Apigee org display name"
  type        = string
  default     = null
}

variable "org_description" {
  description = "Apigee org description"
  type        = string
  default     = "Apigee org created in TF"
}

variable "ax_region" {
  description = "GCP region for storing Apigee analytics data (see https://cloud.google.com/apigee/docs/api-platform/get-started/install-cli)."
  type        = string
}

variable "disable_vpc_peering" {
  description = "Flag that specifies whether the VPC Peering through Private Service Access (Service Networking) should be disabled between the consumer network and Apigee."
  type        = bool
  default     = false
}

variable "network" {
  description = "Network (self-link) to peer with the Apigee tennant project. This is required only for VPC peering based setup through Private Service Access."
  type        = string
  default     = null
}

variable "billing_type" {
  description = "Billing type of the Apigee organization."
  type        = string
  default     = null
}

variable "apigee_envgroups" {
  description = "Apigee environment groups. Accepts both the legacy repo shape and the upstream Fabric map(list(string)) form."
  type        = map(any)
  default     = {}
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

variable "apigee_environments" {
  description = "Apigee environments. Mirrors the upstream Fabric module contract and preserves the repo's legacy fields."
  type = map(object({
    api_proxy_type    = optional(string)
    deployment_type   = optional(string)
    description       = optional(string, "Terraform-managed")
    display_name      = optional(string)
    envgroups         = optional(list(string), [])
    forward_proxy_uri = optional(string)
    iam               = optional(map(list(string)), {})
    iam_bindings = optional(map(object({
      role    = string
      members = list(string)
    })), {})
    iam_bindings_additive = optional(map(object({
      role   = string
      member = string
    })), {})
    node_config = optional(object({
      min_node_count = optional(number)
      max_node_count = optional(number)
    }))
    type = optional(string)
  }))
  default = null
}

variable "apigee_instances" {
  description = "Apigee instances. Mirrors the upstream Fabric module contract and preserves the repo's legacy fields."
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
    description          = optional(string, "Terraform-managed")
    display_name         = optional(string)
    enable_nat           = optional(bool, false)
    activate_nat         = optional(bool, false)
    access_logging = optional(object({
      enabled = optional(bool, true)
      filter  = optional(string)
    }))
  }))
  default = {}
}

variable "org_key_rotation_period" {
  description = "Rotaton period for the organization DB encryption key"
  type        = string
  default     = "2592000s"
}

variable "org_kms_keyring_name" {
  description = "Name of the KMS Key Ring for Apigee Organization DB."
  type        = string
  default     = "apigee-x-org"
}

variable "org_kms_keyring_location" {
  description = "Location of the KMS Key Ring for Apigee Organization DB. Matches AX region if not provided."
  type        = string
  default     = null
}

variable "org_kms_keyring_create" {
  description = "Set to false to manage the keyring for the Apigee Organization DB and IAM bindings in an existing keyring."
  type        = bool
  default     = true
}

variable "inst_kms_keyring_name_prefix" {
  description = "Prefix for the KMS Key Ring name for Apigee X Instance. This will be appended with the region name for the instance"
  type        = string
  default     = "apigee-x"
}

variable "org_retention" {
  description = "Optional. It controls how long Organization data will be retained after the initial delete operation completes. During this period, the Organization may be restored to its last known state. After this period, the Organization will no longer be able to be restored. Default value is DELETION_RETENTION_UNSPECIFIED (retains data for 7 days), Other accepted value : MINIMUM"
  type        = string
  default     = "DELETION_RETENTION_UNSPECIFIED"
}