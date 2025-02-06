variable "azure_vnet_cidr" {
  type        = list(string)
  default     = ["10.248.0.0/16"]
  description = "CIDR block for Vnet"
}

variable "azure_subnet_cidr" {
  type        = list(string)
  default     = ["10.248.1.0/24"]
  description = "CIDR block for Subnet"
}

variable "azure_region" {
  type        = string
  description = "Azure region"
}

variable "project_prefix" {
  type        = string
  description = "This value is inserted at the beginning of each AWS/Azure object (alpha-numeric, no special character)"
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

variable "nap" {
  type = bool
}
variable "nic" {
  type = bool
}
variable "bigip" {
  type = bool
}
variable "bigip-cis" {
  type = bool
}
variable "aks-cluster" {
  type = bool
}
variable "azure-vm" {
  type = bool
}
# Azure public IP
variable "vm_public_ip" {
  type        = string
  description = "Assign Public IP"
  default     = true
}
