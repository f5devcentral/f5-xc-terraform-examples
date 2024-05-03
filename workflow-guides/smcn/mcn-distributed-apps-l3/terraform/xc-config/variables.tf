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

variable "resource_owner" {
  type        = string
  description = "Owner of the deployment, for tagging purposes"
  default     = ""
}

variable "azure_vnet_cidr" {
  type        = string
  description = "CIDR for Azure VNET"
  default     = ""
}

variable "gcp_vnet_cidr" {
  type        = string
  description = "CIDR for GCP VNET"
  default     = ""
}

variable "gcp_vnet_proxy_cird" {
  type        = string
  description = "CIDR for GCP VNET Proxy"
  default     = ""
}

variable "aws_vpc_cidr" {
  type        = string
  description = "CIDR for AWS VPC"
  default     = ""
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
