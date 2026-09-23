variable "project_id" {
  description = "Project id."
  type        = string
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

variable "certificate_prefix" {
  description = "A prefix string for certificate name for the HTTPS LB."
  type        = string
}

variable "external_ip" {
  description = "External IP for the L7 XLB."
  type        = string
  default     = null
}

variable "name" {
  description = "External LB name."
  type        = string
}

variable "hostnames" {
  description = "FQDN for LB"
  type        = list(string)
}

variable "security_policy" {
  description = "(Optional) The security policy associated with this backend service."
  type        = string
  default     = null
}

variable "edge_security_policy" {
  description = "(Optional) The edge security policy associated with this backend service."
  type        = string
  default     = null
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = <<-EOD
  An optional map of label key:value pairs to assign to the forwarding rule.
  Default is an empty map.
  EOD
}

variable "log_enable" {
  description = "Enable Logging for LB backend service"
  type        = bool
  default     = true
}

variable "log_samplerate" {
  description = "Sampling rate of requests. 1.0 means all logged requests are reported, 0.0 means no logged requests are reported"
  type        = number
  default     = 1.0
}