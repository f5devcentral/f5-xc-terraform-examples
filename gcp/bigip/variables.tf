#TF Cloud
variable "tf_cloud_organization" {
  type        = string
  description = "TF cloud org (Value set in TF cloud)"
}

variable "image" {
  type        = string
  description = "BIGIP image name"
  default     = "projects/f5-7626-networks-public/global/images/f5-bigip-17-1-1-4-0-0-9-payg-good-1gbps-240902164747"
}

variable "bigip_password" {
  type        = string
  description = "BIGIP instance password"
  default     = "ApiSecurity@12345"
}
