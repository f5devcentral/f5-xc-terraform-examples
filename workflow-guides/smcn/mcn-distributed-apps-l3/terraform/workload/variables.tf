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

variable "gcp_account_id" {
  type        = string
  description = "GCP account ID"
  default     = ""
}

variable "gke_cluster_name" {
  type        = string
  description = "GKE cluster name"
  default     = ""
}

variable "nic_external_port" {
  type        = string
  description = "External port of the NIC"
  default     = ""
}

variable "nic_external_name" {
  type        = string
  description = "External name of the NIC"
  default     = ""
}

variable "f5xc_sd_sa" {
  type        = string
  description = "Name of the K8s Service Account F5 XC uses for service discovery in EKS"
  default     = "f5xc-sd-serviceaccount"
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

variable "azure_internal_subnet_name" {
  type        = string
  description = "Azure internal subnet name"
  default     = ""
}

# App Workload specific vars
# (Optional) Private docker registry to pull container images
variable "use_private_registry" {
  type        = string
  default     = "false"
  description = "Whether to use an optional private docker registry to pull the app workload container images"
}
variable "registry_server" {
  type = string
  default = "registry.gitlab.com"
  description = "FQDN of the docker registry server"
}
variable "registry_username" {
  type        = string
  default     = ""
  description = "Private docker registry acount username"
}
variable "registry_password" {
  type        = string
  default     = ""
  description = "Private docker registry account password"
}
variable "registry_email" {
  type        = string
  default     = ""
  description = "Private docker registry account email address"
}

# XC WAAP and WAF settings
variable "xc_waf" {
  type        = string
  description = "Enable XC WAF on single LB"
  default     = "false"
}
variable "xc_waf_policy_name" {
  type        = string
  description = "Name of the WAF policy"
  default     = "default"
}

# XC Malicious User Detection
variable "xc_mud" {
  type        = string
  description = "Enable Malicious User Detection on single LB"
  default     = "false"
}

# XC AI/ML Settings for MUD, APIP - NOTE: Only set if using AI/ML settings from the shared namespace
variable "xc_app_type" {
  type        = list
  description = "Set Apptype for shared AI/ML"
  default     = []
}
variable "xc_multi_lb" {
  type        = string
  description = "ML configured externally using app type feature and label added to the HTTP load balancer."
  default     = "false"
}

#XC DDoS Protection
variable "xc_ddos_def" {
  type = string
  description = "Enable XC DDoS Protection"
  default = "false"
}
#XC DDoS Protection
variable "xc_ddos_pro" {
  type = string
  description = "Enable XC DDoS Protection"
  default = "false"
}

#XC Bot Defense
variable "xc_bot_def" {
  type = string
  description = "Enable XC Bot Defense"
  default = "false"
}

#XC API Protection and Discovery
variable "xc_api_disc" {
  type        = string
  description = "Enable API Discovery on single LB"
  default     = "false"
}
variable "xc_api_pro" {
  type        = string
  description = "Enable API Protection (Definition and Rules)"
  default     = "false"
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

#---------------------------------------------
# Google Cloud Platform (GCP) Variables
#---------------------------------------------

# GCP Specific vars - if these are not empty/null, GCP resources will be created
variable "gcp_region" {
  type        = string
  default     = null
  description = "region where GCP resources will be deployed"
}

variable "gcp_project_id" {
  type        = string
  default     = null
  description = "gcp project id"
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
