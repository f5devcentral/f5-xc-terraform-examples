variable "name" {
  type        = string
  description = "Deployment name"
  default     = ""
}

variable "prefix" {
  type        = string
  description = "Prefix for resource names"
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

variable "azure_cloud_credentials_name" {
  type        = string
  description = "Optional. Existing Azure cloud credentials name"
  nullable    = false
  default     = ""
}

# ------------------------------------------------------------
# Azure XC Networking Configuration
# ------------------------------------------------------------

variable "location" {
  description = "The location/region where the VNET will be created. Changing this forces a new resource to be created."
  type        = string
  nullable = false
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the VNET. Changing this forces a new resource to be created."
  type     = string
  nullable = false
}

variable "create_vnet" {
  description = "Whether to create a new VNET. Changing this forces a new resource to be created."
  type        = bool
  default     = true
}

variable "create_resource_group" {
  description = "Whether to create a new resource group for the VNET. Changing this forces a new resource to be created."
  type        = bool
  default     = true
}

variable "create_outside_route_table" {
  description = "Whether to create an outside route table for the outside or local subnets."
  type        = bool
  default     = true
}

variable "create_outside_security_group" {
  description = "Whether to create an outside security group."
  type        = bool
  default     = true
}

variable "create_inside_route_table" {
  description = "Whether to create an inside route table for the inside subnets."
  type        = bool
  default     = true
}

variable "create_inside_security_group" {
  description = "Whether to create an inside security group."
  type        = bool
  default     = true
}

variable "create_udp_security_group_rules" {
  description = "Whether to create UDP security group rules."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "local_subnets" {
  description = "Local Subnet CIDR Blocks."
  type        = list(string)
  default     = []
}

variable "inside_subnets" {
  description = "Inside Subnet CIDR Blocks."
  type        = list(string)
  default     = []
}

variable "outside_subnets" {
  description = "Outside Subnet CIDR Blocks."
  type        = list(string)
  default     = []
}

variable "vnet_cidr" {
  description = "The Primary IPv4 block cannot be modified. All subnets prefixes in this VNET must be part of this CIDR block."
  type        = string
  default     = null
}

variable "disable_bgp_route_propagation" {
  description = "Whether to disable BGP route propagation."
  type        = bool
  default     = false
}