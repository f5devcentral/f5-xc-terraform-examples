#Project
variable "project_prefix" {
  type        = string
  description = "This value is inserted at the beginning of each AWS object (alpha-numeric, no special character)"
}
#XC Base
variable "xc_tenant" {
  type        = string
  description = "Your F5 XC tenant name"
}
variable "api_url" {
  type        = string
  description = "Your F5 XC tenant api url"
}
/*
variable "api_p12_file" {
  type        = string
  description = "Your F5 XC tenant api p12 file"
}
*/
variable "xc_namespace" {
  type        = string
  description = "Volterra app namespace where the object will be created. This cannot be system or shared ns."
}
variable "app_domain" {
  type        = string
  description = "FQDN for the app. If you have delegated domain `prod.example.com`, then your app_domain can be `<app_name>.prod.example.com`"
}
variable "dns_origin_pool" {
  type        = string
  description = "Set to true if pool member is FQDN"
}
variable "origin_server" {
  type        = string
  description = "Origin server IP address"
}
variable "origin_port" {
  type        = string
  description = "Origin server port"
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
variable "xc_api_val_active" {
  type        = string
  description = "Enable API Validation on active endpoints"
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

