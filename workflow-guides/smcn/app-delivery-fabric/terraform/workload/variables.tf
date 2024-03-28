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

variable "namespace" {
  type        = string
  description = "Namespace for the workload"
  default     = ""
}

variable "app_domain" {
  type        = string
  description = "FQDN for the app"
  default     = ""
}

variable "azure_site_name" {
  type        = string
  description = "Azure site name"
  default     = ""
}

variable "aws_site_name" {
  type        = string
  description = "AWS site name"
  default     = ""
}

variable "azure_resource_group_name" {
  type        = string
  description = "Azure resource group name"
  default     = ""
}

variable "aks_cluster_name" {
  type        = string
  description = "AKS cluster name"
  default     = ""
}


variable "create_aks_namespace" {
  type        = string
  description = "Create a new namespace for the AKS cluster"
  default     = "true"
}

variable "create_eks_namespace" {
  type        = string
  description = "Create a new namespace for the EKS cluster"
  default     = "true"
}

variable "create_xc_namespace" {
  type        = string
  description = "Create a new namespace for the XC Cloud"
  default     = "true"
}

variable "xc_security_group_id" {
  type        = string
  description = "XC Cloud security group ID"
  default     = ""
}

# ------------------------------------------------------------
# Azure Cloud Configuration
# ------------------------------------------------------------

variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "azure_tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "azure_client_id" {
  description = "Optional. Azure Client ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "azure_client_secret" {
  description = "Optional. Azure Client Secret"
  type      = string
  sensitive = true
  default   = null
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

variable "aks_node_private_ip" {
  type        = string
  description = "AKS node private IP"
  default     = ""
}

variable "eks_node_private_ip" {
  type        = string
  description = "EKS node private IP"
  default     = ""
}

variable "aws_xc_inside_subnet_id" {
  type        = string
  description = "AWS XC internal subnet ID"
  default     = ""
}

variable "aws_xc_outside_subnet_id" {
  type        = string
  description = "AWS XC public subnet ID"
  default     = ""
}

variable "aws_xc_node_inside_ip" {
  type        = string
  description = "AWS XC node internal IP"
  default     = ""
}

variable "aws_xc_node_outside_ip" {
  type        = string
  description = "AWS XC node public IP"
  default     = ""
}

variable "aws_vpc_id" {
  type        = string
  description = "AWS VPC ID"
  default     = ""
}

#---------------------------------------------
# XC Cloud Provider Configuration
#---------------------------------------------

variable "xc_api_url" {
  description = "XC Cloud API URL"
  type        = string
  default     = null
}

variable "xc_api_p12_file" {
  description = "Path to XC Cloud API certificate"
  type        = string
  default     = null
}

#---------------------------------------------
# EKS Kubernetes Configuration
#---------------------------------------------

variable "eks_cluster_name" {
  type        = string
  description = "EKS cluster name"
  default     = ""
}

variable "eks_cluster_host" {
  description = "EKS Kubernetes API server endpoint"
  type        = string
  default     = ""
}

variable "eks_cluster_ca_certificate" {
  description = "EKS Kubernetes API server certificate"
  type        = string
  default     = ""
}
