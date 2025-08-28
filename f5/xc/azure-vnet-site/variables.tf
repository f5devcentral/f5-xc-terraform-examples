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

#------------------------------------------------
# F5 XC Cloud Configuration
#------------------------------------------------

variable "xc_api_url" {
  description = "F5 XC Cloud API URL"
  type        = string
  sensitive   = true
  default     = null
}

variable "xc_api_p12_file" {
  description = "Path to F5 XC Cloud API certificate"
  type        = string
  sensitive   = true
  default     = null
}

#------------------------------------------------
# Azure Configuration
#------------------------------------------------

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

#------------------------------------------------
# Azure VNET Site Configuration
#------------------------------------------------

variable "site_description" {
  description = "The description for the Azure VNET Site that will be configured."
  type        = string
  default     = null
}

variable "site_namespace" {
  description = "The namespace where Azure VNET Site that will be configured."
  type        = string
  default     = "system"
  nullable    = false
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = string
  default     = ""
}

variable "offline_survivability_mode" {
  description = "Enable/Disable offline survivability mode."
  type        = string
  default     = ""
}

variable "software_version" {
  description = "F5XC Software Version is optional parameter, which allows to specify target SW version for particular site e.g. crt-20210329-1002."
  type        = string
  default     = null
}

variable "operating_system_version" {
  description = "Operating System Version is optional parameter, which allows to specify target OS version for particular site e.g. 7.2009.10."
  type        = string
  default     = null
}

variable "site_type" {
  description = "The site_type variable is used to specify the type of site that will be deployed. Available values: ingress_gw, ingress_egress_gw, app_stack"
  type        = string
  default     = "ingress_gw"
}


variable "master_nodes_az_names" {
  description = "Availability Zone Names for Master Nodes: 1, 2, 3"
  type        = list(string)
  default     = []
}

variable "nodes_disk_size" {
  description = "Disk size to be used fornodes in GiB. 80 is 80 GiB."
  type        = string
  default     = ""
}

#-----------------------------------------------------------
# SSH Key
#-----------------------------------------------------------

variable "ssh_key" {
  description = "Public SSH key for accessing the Azure VNET Site. If not provided, a new key will be generated."
  type        = string
  default     = null
}

#-----------------------------------------------------------
# Azure
#-----------------------------------------------------------

variable "azure_rg_location" {
  description = "Azure Resource Group Location."
  type        = string
  nullable    = false
}

variable "azure_rg_name" {
  description = "Name of the Azure Resource Group that will be created for Azure VNET Site."
  type        = string
  default     = null
}

variable "machine_type" {
  description = "Select VM size based on performance needed."
  type        = string
  default     = "Standard_D3_v2"
}

#-----------------------------------------------------------
# Azure Cloud Credentials
#-----------------------------------------------------------

variable "az_cloud_credentials_name" {
  description = "Azure Cloud Credentials Name."
  type        = string
  default     = null
}

variable "az_cloud_credentials_namespace" {
  description = "Azure Cloud Credentials Namespace."
  type        = string
  default     = "system"
}

variable "az_cloud_credentials_tenant" {
  description = "Azure Cloud Credentials Tenant."
  type        = string
  default     = null
}

#-----------------------------------------------------------
# L3 Performance Mode
#-----------------------------------------------------------

variable "jumbo" {
  description = "L3 performance mode enhancement to use jumbo frame."
  type        = string
  default     = ""
}

#-----------------------------------------------------------
# Logs Streaming
#-----------------------------------------------------------

variable "log_receiver" {
  description = "Select log receiver for logs streaming."
  type        = string
  default     = ""
}

#-----------------------------------------------------------
# VNET
#-----------------------------------------------------------

variable "vnet_name" {
  description = "The Name of the Azure VNET where the resources will be provisioned."
  type        = string
  default     = null
}

variable "vnet_rg_name" {
  description = "The name of the Azure Resource Groups where VNET will be provisioned."
  type        = string
  default     = null
}

variable "vnet_rg_location" {
  description = "The location/region where the VNET will be created. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "vnet_cidr" {
  description = "The Primary IPv4 block cannot be modified. All subnets prefixes in this VNET must be part of this CIDR block."
  type        = string
  default     = null
}

variable "apply_outside_sg_rules" {
  description = "Apply Azure Security Group Rules with whitelisted IPs for the Security Group created by XC Cloud."
  type        = string
  default     = ""
}

variable "existing_inside_rt_names" {
  description = "If you want to use existing route tables, provide the route table names here."
  type        = list(string)
  default     = []
}

#-----------------------------------------------------------
# Subnets
#-----------------------------------------------------------

variable "existing_local_subnets" {
  description = "If you want to use existing subnets, provide the subnet IDs here."
  type        = list(string)
  default     = []
}

variable "existing_inside_subnets" {
  description = "If you want to use existing subnets, provide the subnet IDs here."
  type        = list(string)
  default     = []
}

variable "existing_outside_subnets" {
  description = "If you want to use existing subnets, provide the subnet IDs here."
  type        = list(string)
  default     = []
}

variable "local_subnets" {
  description = "Local Subnets for the Site."
  type        = list(string)
  default     = []
}

variable "inside_subnets" {
  description = "Inside Subnets for the Site."
  type        = list(string)
  default     = []
}

variable "outside_subnets" {
  description = "Outside Subnets for the Site."
  type        = list(string)
  default     = []
}

#-----------------------------------------------------------
# Worker Nodes
#-----------------------------------------------------------

variable "worker_nodes_per_az" {
  description = "Desired Worker Nodes Per AZ. Max limit is up to 21."
  type        = string
  default     = ""
}

#-----------------------------------------------------------
# Blocked Services
#-----------------------------------------------------------

variable "block_all_services" {
  description = "Block DNS, SSH & WebUI services on Site."
  type        = string
  default     = ""
}


variable "blocked_service" {
  description = "Use custom blocked services configuration."
  type        = string
  default     = ""
}

#-----------------------------------------------------------
# DC Cluster Group
#-----------------------------------------------------------

variable "dc_cluster_group_inside_vn" {
  description = "This site is member of dc cluster group connected via inside network."
  type        = string
  default     = ""
}

variable "dc_cluster_group_outside_vn" {
  description = "This site is member of dc cluster group connected via outside network."
  type        = string
  default     = ""
}

#-----------------------------------------------------------
# Forward Proxy
#-----------------------------------------------------------

variable "active_forward_proxy_policies_list" {
  description = "List of Forward Proxy Policies."
  type = list(object({
    name      = string
    namespace = optional(string)
    tenant    = optional(string)
  }))
  default = []
}

variable "forward_proxy_allow_all" {
  description = "Enable Forward Proxy for this site and allow all requests."
  type        = string
  default     = ""
}

#-----------------------------------------------------------
# Global Network
#-----------------------------------------------------------

variable "global_network_connections_list" {
  description = "Global network connections."
  type = list(object({
    sli_to_global_dr = optional(object({
      global_vn  = object({
        name      = string
        namespace = optional(string)
        tenant    = optional(string)
      })
    }))
    slo_to_global_dr = optional(object({
      global_vn  = object({
        name      = string
        namespace = optional(string)
        tenant    = optional(string)
      })
    }))
  }))
  default = []
}

#-----------------------------------------------------------
# Static Routes
#-----------------------------------------------------------

variable "inside_static_route_list" {
  description = "List of Inside Static routes."
  type = list(object({
    custom_static_route = optional(object({
      attrs = optional(list(string))
      labels = optional(string)
      nexthop = optional(object({
        interface = optional(object({
          name      = string
          namespace = optional(string)
          tenant    = optional(string)
        }))
        nexthop_address = optional(object({
          ipv4 = optional(object({
            addr = optional(string)
          }))
          ipv6 = optional(object({
            addr = optional(string)
          }))
        }))
        type = optional(string)
      }))
      subnets = object({
        ipv4 = optional(object({
          plen   = optional(number)
          prefix = optional(string)
        }))
        ipv6 = optional(object({
          plen   = optional(number)
          prefix = optional(string)
        }))
      })
    }))
    simple_static_route = optional(string)
  }))
  default = []
}

variable "outside_static_route_list" {
  description = "List of Outside Static routes."
  type = list(object({
    custom_static_route = optional(object({
      attrs = optional(list(string))
      labels = optional(string)
      nexthop = optional(object({
        interface = optional(object({
          name      = string
          namespace = optional(string)
          tenant    = optional(string)
        }))
        nexthop_address = optional(object({
          ipv4 = optional(object({
            addr = optional(string)
          }))
          ipv6 = optional(object({
            addr = optional(string)
          }))
        }))
        type = optional(string)
      }))
      subnets = object({
        ipv4 = optional(object({
          plen   = optional(number)
          prefix = optional(string)
        }))
        ipv6 = optional(object({
          plen   = optional(number)
          prefix = optional(string)
        }))
      })
    }))
    simple_static_route = optional(string)
  }))
  default = []
}

#-----------------------------------------------------------
# Network Policies
#-----------------------------------------------------------

variable "enhanced_firewall_policies_list" {
  description = "Ordered List of Enhaned Firewall Policy active for this network firewall."
  type = list(object({
    name      = string
    namespace = optional(string)
    tenant    = optional(string)
  }))
  default = []
}

variable "active_network_policies_list" {
  description = "Ordered List of Firewall Policies active for this network firewall."
  type = list(object({
    name      = string
    namespace = optional(string)
    tenant    = optional(string)
  }))
  default = []
}

#-----------------------------------------------------------
# IP SEC
#-----------------------------------------------------------

variable "sm_connection_public_ip" {
  description = "Creating ipsec between two sites which are part of the site mesh group."
  type        = string
  default     = ""
}