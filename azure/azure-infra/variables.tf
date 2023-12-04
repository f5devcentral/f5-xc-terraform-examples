variable "azure_vnet_cidr" {
  type        = list(string)
  default     = ["192.168.0.0/16"]
  description = "CIDR block for Vnet"
}

variable "azure_subnet_cidr" {
  type        = list(string)
  default     = ["192.168.1.0/24"]
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
  type    = string
}

variable "azure_subscription_tenant_id" {
  type    = string
}

variable "azure_service_principal_appid" {
  type    = string
}

variable "azure_service_principal_password" {
  type    = string
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
