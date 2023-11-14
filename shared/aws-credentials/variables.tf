variable "name" {
  type        = string
  description = "Deployment name"
  default     = "teachable"
}

variable "prefix" {
  type        = string
  description = "Prefix for resource names"
  default     = null
}

#------------------------------------------------
# F5 XC Cloud Configuration
#------------------------------------------------

variable "xc_api_url" {
  description = "F5 XC Cloud API URL"
  type        = string
  default     = "https://your_xc-cloud_api_url.console.ves.volterra.io/api"
}

variable "xc_api_p12_file" {
  description = "Path to F5 XC Cloud API certificate"
  type        = string
  default     = "./api.p12"
}

#------------------------------------------------
# AWS Configuration
#------------------------------------------------

variable "aws_access_key" {
  type        = string
  default     = null
  description = "AWS access key"
}

variable "aws_secret_key" {
  type        = string
  sensitive   = true
  description = "AWS secret key"
  default     = null
}

variable "aws_token" {
  type        = string
  default     = null
  description = "AWS Session token"
}

variable "aws_cloud_credentials_name" {
  type        = string
  description = "Optional. Existing AWS cloud credentials name"
  nullable    = false
  default     = ""
}

variable "aws_region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region"
}

variable "aws_create_iam_user" {
  type        = bool
  description = "Optional. Specify 'true' to create a IAM User. Default is 'false'"
  default     = false
}
#------------------------------------------------
# Alternative AWS Configuration
# This is used when you need to use a different 
# credentials for AWS than the one used for XC Cloud
#------------------------------------------------

variable "xc_aws_access_key" {
  type        = string
  default     = null
  description = "AWS access key"
}

variable "xc_aws_secret_key" {
  type        = string
  sensitive   = true
  description = "AWS secret key"
  default     = null
}