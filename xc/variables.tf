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
#XC WAF
variable "xc_waf_blocking" {
  type        = string
  description = "Set XC WAF to Blocking(true) or Monitoring(false)"
  default     = "false"
}
#XC AI/ML Settings for MUD, APIP - NOTE: Only set if using AI/ML settings from the shared namespace
variable "xc_app_type" {
  type        = list
  description = "Set Apptype for shared AI/ML"
  default     = null
}
variable "xc_multi_lb" {
  type        = string
  description = "ML configured externally using app type feature and label added to the HTTP load balancer."
  default     = "false"
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
variable "xc_api_spec" {
  type        = list
  description = "XC object store path to swagger spec ex: https://my.tenant.domain/api/object_store/namespaces/my-ns/stored_objects/swagger/file-name/v1-22-01-12"
  default     = null
}
#XC Bot Defense
variable "xc_bot_def" {
  type = string
  description = "Enable XC Bot Defense"
  default = "false"
}
#XC DDoS Protection
variable "xc_ddos_pro" {
  type = string
  description = "Enable XC DDoS Protection"
  default = "false"
}
#XC Malicious User Detection
variable "xc_mud" {
  type        = string
  description = "Enable Malicious User Detection on single LB"
  default     = "false"
}

# k8s backend
variable "k8s_pool" {
  type        = string
  description = "Whether pool member is k8s backend ?"
  default     = "false"
}

variable "advertise_sites" {
  type        = string
  description = "Boolean to check if app needs to be advertised on given sites."
  default     = "false"
}

variable "http_only" {
  type        = string
  description = "If need to be configured on http protocol. Use this as True for CE site deployments."
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

variable "site_name" {
  type        = string
  description = "CE site name to advertise load balancer."
  default     = ""
}

# Azure CE Site 
variable "az_ce_site" {
  type        = string
  description = "If infra is deployed as Azure CE site ?"
  default     = "false"
}

variable "azure_subscription_id" {
  type    = string
}


variable "azure_subscription_tenant_id" {
  type    = string
}

variable "azure_service_principal_appid" {
  type    = string
}

variable "azure_service_principal_password" {
  type    = string
}

variable "azure_xc_machine_type" {
  type    = string
  default = "Standard_D3_v2"
}

# XC Service Discovery
variable "xc_service_discovery" {
  type        = string
  description = "Enable service discovery"
  default     = "false"
}

variable "gcp_ce_site" {
  type        = string
  description = "If infra is deployed in GCP CE site ?"
  default     = "false"
}

variable "GOOGLE_CREDENTIALS" {
  type        = string
  description = "Contents of GCP credentials file to create CE site"
}
