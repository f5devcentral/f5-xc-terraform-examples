variable "tf_cloud_organization" {
  type = string
  description = "TF cloud org (Value set in TF cloud)"
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

variable "f5_bigip_image" {
  type    = string
  default = "f5-big-best-plus-hourly-25mbps"
}

variable "f5_bigip_password" {
  type    = string
  description = "BIGIP instance password"
  default     = "Siddarth@12345"
}

variable "availability_zone" {
  description = "If you want the VM placed in an Azure Availability Zone, and the Azure region you are deploying to supports it, specify the number of the existing Availability Zone you want to use."
  default     = 1
}

variable "availabilityZones_public_ip" {
  description = "The availability zone to allocate the Public IP in. Possible values are Zone-Redundant, 1, 2, 3, and No-Zone."
  type        = string
  default     = "Zone-Redundant"
}