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

variable "node_subnet_id" {
  type        = string
  description = "Azure Subnet ID for AKS nodes"
  default     = ""
}

variable "azure_rg_id" {
  type        = string
  description = "Azure Resource Group ID"
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
