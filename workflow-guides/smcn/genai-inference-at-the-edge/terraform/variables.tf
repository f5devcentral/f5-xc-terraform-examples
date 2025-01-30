#TF Cloud
variable "tf_cloud_organization" {
  type        = string
  description = "TF cloud org (Value set in TF cloud)"
}

variable "ssh_key" {
  type        = string
  description = "SSH pub key, only present for warning handling with TF cloud variable set"
}

#XC
variable "project_prefix" {
  type        = string
  default     = "xcdemo"
  description = "This value is inserted at the beginning of each XC object and only used if not set by Infra TF run"
}

variable "xc_tenant" {
  type        = string
  description = "Your F5 XC tenant name" 
}

variable "api_url" {
  type        = string
  description = "Your F5 XC tenant api url"
}

variable "xc_namespace" {
  type        = string
  description = "Volterra app namespace where the object will be created. This cannot be system or shared ns."
}

variable "app_domain" {
  type        = string
  description = "FQDN for the app. If you have delegated domain `prod.example.com`, then your app_domain can be `<app_name>.prod.example.com`"
}

#XC WAF
variable "xc_waf_blocking" {
  type        = string
  description = "Set XC WAF to Blocking(true) or Monitoring(false)"
  default     = "false"
}

# k8s service name
variable "serviceName" {
  type        = string
  description = "k8s backend service details to access the demo application"
  default     = ""
}

variable "serviceport" {
  type        = string
  description = "k8s backend application service port details"
  default     = ""
}

variable "aws_region" {
  type        = string
  description = "AWS Region."
  default     = "ap-south-1"
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

variable "primary_ipv4" {
  type        = string
  description = "IPv4 VPC range."
  default     = "10.0.0.0/16"
}

variable "subnet_ipv4" {
  type        = string
  description = "IPv4 range of subnet."
  default     = "10.0.0.0/24"
}

