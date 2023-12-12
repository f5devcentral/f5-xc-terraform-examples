variable "gcp_region" {
  description = "GCP region name"
  type        = string
  default     = "asia-south1"
}

variable "cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "gcp_project_id" {
  type    = string
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
