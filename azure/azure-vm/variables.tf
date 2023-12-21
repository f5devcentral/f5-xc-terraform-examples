variable "tf_cloud_organization" {
  type = string
  description = "TF cloud org (Value set in TF cloud)"
}

variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "azure_subscription_tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "azure_service_principal_appid" {
  description = "Azure Client ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "azure_service_principal_password" {
  description = "Azure Client Secret"
  type      = string
  sensitive = true
  default   = null
}

variable "source_ip" {
  type        = string
  description = "IP address allowed to make ssh connections"
}