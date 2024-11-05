#TF Cloud
variable "tf_cloud_organization" {
  type        = string
  description = "TF cloud org (Value set in TF cloud)"
}

variable "aws_waf_ce" {
  description = "Infra"
  type        = string
  default     = "aws-infra"
}
