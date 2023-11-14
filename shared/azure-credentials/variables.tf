variable "name" {
  type        = string
  description = "Deployment name"
  default     = "teachable"
}

variable "prefix" {
  type        = string
  description = "Prefix for resource names"
  default     = null
}

#------------------------------------------------
# F5 XC Cloud Configuration
#------------------------------------------------

variable "xc_api_url" {
  description = "F5 XC Cloud API URL"
  type        = string
  default     = "https://your_xc-cloud_api_url.console.ves.volterra.io/api"
}

variable "xc_api_p12_file" {
  description = "Path to F5 XC Cloud API certificate"
  type        = string
  sensitive   = true
  default     = "./api.p12"
}

#------------------------------------------------
# Azure Configuration
#------------------------------------------------

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

variable "azure_cloud_credentials_name" {
  type        = string
  description = "Optional. Existing Azure cloud credentials name"
  nullable    = false
  default     = ""
}

variable "azure_create_sa" {
  type        = bool
  description = "Optional. Specify 'true' to create a new service account. Default is 'false'"
  default     = false
}

#------------------------------------------------
# Alternative Azure Configuration
# This is used when you need to use a different 
# credentials for Azure than the one used for XC Cloud
#------------------------------------------------

variable "xc_azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "xc_azure_tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "xc_azure_client_id" {
  description = "Optional. Azure Client ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "xc_azure_client_secret" {
  description = "Optional. Azure Client Secret"
  type      = string
  sensitive = true
  default   = null
}
