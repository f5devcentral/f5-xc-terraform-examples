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
  type        = list(any)
  description = "XC object store path to swagger spec ex: https://my.tenant.domain/api/object_store/namespaces/my-ns/stored_objects/swagger/file-name/v1-22-01-12"
  default     = null
}
variable "xc_api_val" {
  type        = string
  description = "Enable API Validation"
  default     = "false"
}
variable "xc_api_val_all" {
  type        = string
  description = "Enable API Validation on all endpoints"
  default     = "false"
}
variable "xc_api_val_properties" {
  type    = list(string)
  default = ["PROPERTY_QUERY_PARAMETERS", "PROPERTY_PATH_PARAMETERS", "PROPERTY_CONTENT_TYPE", "PROPERTY_COOKIE_PARAMETERS", "PROPERTY_HTTP_HEADERS", "PROPERTY_HTTP_BODY"]

}
variable "xc_resp_val_properties" {
  type    = list(string)
  default = ["PROPERTY_HTTP_HEADERS", "PROPERTY_CONTENT_TYPE", "PROPERTY_HTTP_BODY", "PROPERTY_RESPONSE_CODE"]
}
variable "xc_api_val_active" {
  type        = string
  description = "Enable API Validation on active endpoints"
  default     = "false"
}
variable "xc_resp_val_active" {
  type        = string
  description = "Enable response API Validation on active endpoints"
  default     = "false"
}
variable "enforcement_block" {
  type        = string
  description = "Enable enforcement block"
  default     = "false"
}
variable "enforcement_report" {
  type        = string
  description = "Enable enforcement report"
  default     = "false"
}
variable "fall_through_mode_allow" {
  type        = string
  description = "Enable fall through mode allow"
  default     = "false"
}
variable "xc_api_val_custom" {
  type        = string
  description = "Enable API Validation custom rules"
  default     = "false"
}
#JWT Validation
variable "xc_jwt_val" {
  type        = string
  description = "Enable JWT Validation"
  default     = "false"
}
variable "jwt_val_block" {
  type        = string
  description = "Enable JWT Validation block"
  default     = "false"
}
variable "jwt_val_report" {
  type        = string
  description = "Enable JWT Validation report"
  default     = "false"
}
variable "jwks" {
  type        = string
  description = "JWK for validation"
  default     = "app_domain" 
}
variable "iss_claim" {
  type        = string
  description = "JWT Validation issuer claim"
  default     = "false"
}
variable "aud_claim" {
  type        = list(string)
  description = "JWT Validation audience claim"
  default     = [""]
}
variable "val_period_enable" {
  type        = string
  description = "JWT Validation expiration claim"
  default     = "false"
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

variable user_site {
  type        = string
  description = "Whether site is owned by user of F5 XC."
  default     = "false"
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
  type      = string
  sensitive = true
  default   = null
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
  default     = "false"
}


# EKS CE Site
variable "eks_ce_site" {
  type        = string
  description = "Whether it's EKS CE site ?"
  default     = "false"
}

variable "xc_delegation" {
  type        = string
  description = "F5 XC Domain delegation"
  default     = "false"
}

variable "ip_address_on_site_pool" {
  type        = string
  description = "If pool member is Private IP on given sites"
  default     = "false"
}

# EKS CE Site with F5 XC Volt Mesh
variable "aws_ce_site" {
  type        = string
  description = "Whether it's EKS site for AWS CE ?"
  default     = "false"
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

variable "azure" {
  description = "Workspace name of Azure deployment infra"
  type        = string
  default     = ""
}

variable "aws" {
  description = "Workspace name of AWS deployment infra"
  type        = string
  default     = ""
}

variable "gcp" {
  description = "Workspace name of GCP deployment infra"
  type        = string
  default     = ""
}

variable "xc_project_prefix" {
  type        = string
  default     = "xcdemo"
  description = "This value is inserted at the beginning of each XC object and only used if not set by Infra TF run"
}

variable "vk8s" {
  description = "Boolean to check if infra has vk8s"
  type        = bool
  default     = false
}
