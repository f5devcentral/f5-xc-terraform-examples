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

variable "xc_api_url" {
  description = "F5 XC Cloud API URL"
  type        = string
  default     = null
}

variable "xc_api_p12_file" {
  description = "Path to F5 XC Cloud API certificate"
  type        = string
  default     = null
}

variable "aws_vpc_id" {
  type        = string
  description = "AWS VPC ID"
  default     = ""
}
