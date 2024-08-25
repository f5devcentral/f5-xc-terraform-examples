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


variable "gke_site_name" {
  type        = string
  description = "Name of the GKE CE site."
  default     = ""
}

variable "gcp_instance_type" {
  default = "n1-standard-4"
}


variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "azure_subscription_tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "azure_service_principal_appid" {
  description = "Azure Client ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "azure_service_principal_password" {
  description = "Azure Client Secret"
  type        = string
  sensitive   = true
  default     = null
}

variable "azure_xc_machine_type" {
  type        = string
  default     = "Standard_D3_v2"
}

variable "GOOGLE_CREDENTIALS" {
  type        = string
  description = "Contents of GCP credentials file to create CE site"
  default     = "false"
}
