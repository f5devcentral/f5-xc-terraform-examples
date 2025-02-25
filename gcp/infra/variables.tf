variable "gcp_region" {
  description = "GCP region name"
  type        = string
  default     = "asia-south1"
}

variable "cidr" {
  description = "CIDR to create subnet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "gcp_project_id" {
  type    = string
}

variable "service_account" {
  type    = string
  default = ""
}

variable "project_prefix" {
  type        = string
  description = "This value is inserted at the beginning of each cloud object (alpha-numeric, no special character)"
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
  default = false
}
variable "azure-vm" {
  type = bool
  default = false
}
