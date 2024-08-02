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

variable "k8s_host" {
  type        = string
  description = "K8s host"
  default     = ""
}

variable "k8s_ca_certificate" {
  type        = string
  description = "Base64 encoded K8s CA certificate"
  default     = ""
}

variable "eks_cluster_name" {
  type        = string
  description = "EKS cluster name"
  default     = ""
}

#------------------------------------------------
# NGINX Configuration
#------------------------------------------------

variable nginx_registry {
    type = string
    description = "NGINX docker regstery"
    default = "private-registry.nginx.com"
}
variable nginx_jwt {
    type = string
    description = "JWT for pulling NGINX image"
    default = "nginx_repo.jwt"
}

#------------------------------------------------
# AWS Provider Configuration
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

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}