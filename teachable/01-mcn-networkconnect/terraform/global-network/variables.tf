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

variable "xc_api_url" {
  description = "F5 XC Cloud API URL"
  type        = string
  default     = null
}

variable "xc_api_p12_file" {
  description = "Path to F5 XC Cloud API certificate"
  type        = string
  default     = null
}

variable "azure_site_name" {
  type        = string
  description = "Azure Vnet Site Name"
  default     = ""
}

variable "aws_vm_private_ip" {
  type        = string
  description = "AWS VM Private IP"
  default     = ""
}

variable "azure_vm_private_ip" {
  type        = string
  description = "Azure VM Private IP"
  default     = ""
}

variable "azure_rg_location" {
  type        = string
  description = "Azure Resource Group Location"
  default     = ""
}

variable "azure_rg_name" {
  type        = string
  description = "Azure Resource Group Name"
  default     = ""
}

variable "aws_workload_subnet_ids" {
  type        = list(string)
  description = "AWS Workload Subnet IDs"
  default     = []
}

variable "azure_inside_subnet_names" {
  type        = list(string)
  description = "Azure Inside Subnet Name"
  default     = []
}

variable "azure_vnet_name" {
  type        = string
  description = "Azure Vnet Name"
  default     = ""
}

variable "aws_vpc_cidr" {
  type        = string
  description = "AWS VPC CIDR"
  default     = ""
}

variable "azure_vnet_cidr" {
  type        = string
  description = "Azure VNet CIDR"
  default     = ""
}

variable "aws_vpc_id" {
  type        = string
  description = "AWS VPC ID"
  default     = ""
}

# ------------------------------------------------------------
# Azure Cloud Configuration
# ------------------------------------------------------------

variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "azure_tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "azure_client_id" {
  description = "Optional. Azure Client ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "azure_client_secret" {
  description = "Optional. Azure Client Secret"
  type      = string
  sensitive = true
  default   = null
}

#------------------------------------------------
# AWS Provider Configuration
#------------------------------------------------

variable "aws_access_key" {
  type        = string
  default     = null
  description = "AWS access key"
}

variable "aws_secret_key" {
  type        = string
  sensitive   = true
  description = "AWS secret key"
  default     = null
}

variable "aws_token" {
  type        = string
  default     = null
  description = "AWS Session token"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}
