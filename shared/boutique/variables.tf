#TF Cloud
variable "tf_cloud_organization" {
  type = string
  description = "TF cloud org (Value set in TF cloud)"
}

variable "ssh_key" {
  type        = string
  description = "Only present for warning handling with TF cloud variable set"
}

variable "aws_access_key" {
  description = "AWS Access Key ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "aws_secret_key" {
  description = "AWS Secret Key ID"
  type        = string
  sensitive   = true
  default     = null
}