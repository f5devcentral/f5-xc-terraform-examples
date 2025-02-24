#TF Cloud
variable "tf_cloud_organization" {
  type        = string
  description = "TF cloud org (Value set in TF cloud)"
}

# XC Bot Connector Variables
variable "application_id" {
  description = "XC Application ID"
  type        = string
  default     = ""
}

variable "tenant_id" {
  description = "XC Tenant ID"
  type        = string
  default     = ""
}

variable "telemetry_header_prefix" {
  description = "Telemetry Header Prefix"
  type        = string
  default     = ""
}

variable "api_key" {
  description = "XC API Key"
  type        = string
  default     = ""
}
