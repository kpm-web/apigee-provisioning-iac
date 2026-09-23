
variable "project_id" {
  description = "Project id."
  type        = string
}

variable "backend_migs" {
  description = "List of MIGs to be used as backends."
  type        = list(string)
}

variable "name" {
  description = "External LB name."
  type        = string
}

variable "cert_cn" {
  description = "CN for the temporary certificate"
  type        = string
  default     = "temp-cert"
}

variable "cert_org" {
  description = "Org name for the temporary certificate"
  type        = string
  default     = "DummyOrg"
}

variable "cert_domain" {
  description = "Domains for the temporary certificate"
  type        = list(string)
  default     = ["dummyorg.com"]
}

variable "cert_validity" {
  description = "Temporary certificate validity in hours"
  type        = number
  default     = 24
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
