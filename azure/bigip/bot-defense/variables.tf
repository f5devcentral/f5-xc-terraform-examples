variable "tf_cloud_organization" {
  type = string
  description = "TF cloud org (Value set in TF cloud)"
}
# XC Bot Connector Variables
variable "xc_application_id" {
  description = "XC Application ID"
  type        = string
  default     = ""
}

variable "xc_tenant_id" {
  description = "XC Tenant ID"
  type        = string
  default     = ""
}

variable "xc_telemetry_header_prefix" {
  description = "Telemetry Header Prefix"
  type        = string
  default     = ""
}

variable "xc_api_key" {
  description = "XC API Key"
  type        = string
  default     = ""
}

variable "xc_web_api_hostname" {
  description = "XC Web API Hostname"
  type        = string
  default     = ""
}