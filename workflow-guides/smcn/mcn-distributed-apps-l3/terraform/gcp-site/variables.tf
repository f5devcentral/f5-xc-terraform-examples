variable "name" {
  type        = string
  description = "Workload name"
  default     = ""
}

variable "prefix" {
  type        = string
  description = "Prefix for resource names"
  default     = ""
}

variable "ssh_key" {
  type        = string
  description = "SSH public key"
  default     = null
}

variable "zones" {
  type        = list(string)
  description = "List of zones to use for resources"
  default     = null
}

variable "xc_gcp_credentials" {
  type        = string
  description = "GCP credentials to use with GCP Site"
  default     = null
}

variable "xc_gcp_cloud_credentials" {
  type        = string
  description = "GCP Cloud credentials to use with GCP Site"
  default     = ""
}

variable "slo_cidr" {
  type        = string
  description = "CIDR for SLO"
  default     = null
}

variable "sli_cird" {
  type        = string
  description = "CIDR for SLI"
  default     = null
}

variable "proxy_cidr" {
  type        = string
  description = "CIDR for Proxy"
  default     = null
}

variable "xc_global_vn_name" {
  type        = string
  description = "Global VN name"
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

#---------------------------------------------
# Google Cloud Platform (GCP) Variables
#---------------------------------------------

# GCP Specific vars - if these are not empty/null, GCP resources will be created
variable "gcp_region" {
  type        = string
  default     = null
  description = "region where GCP resources will be deployed"
}

variable "gcp_project_id" {
  type        = string
  default     = null
  description = "gcp project id"
}

#---------------------------------------------
# XC Cloud Provider Configuration
#---------------------------------------------

variable "xc_api_url" {
  description = "XC Cloud API URL"
  type        = string
  default     = null
}

variable "xc_api_p12_file" {
  description = "Path to XC Cloud API certificate"
  type        = string
  default     = null
}