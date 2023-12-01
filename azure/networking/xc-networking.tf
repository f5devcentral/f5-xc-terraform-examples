module "xc_azure_vnet" {
  source  = "f5devcentral/azure-vnet-site-networking/xc"
  version = "0.0.1"

  name                            = var.prefix != "" ? format("%s-%s", var.prefix, var.name) : var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  create_vnet                     = var.create_vnet != "" ? tobool(var.create_vnet) : true
  create_resource_group           = var.create_resource_group != "" ? tobool(var.create_resource_group) : true
  create_outside_route_table      = var.create_outside_route_table != "" ? tobool(var.create_outside_route_table) : true
  create_outside_security_group   = var.create_outside_security_group != "" ? tobool(var.create_outside_security_group) : true
  create_inside_route_table       = var.create_inside_route_table != "" ? tobool(var.create_inside_route_table) : true
  create_inside_security_group    = var.create_inside_security_group != "" ? tobool(var.create_inside_security_group) : true
  create_udp_security_group_rules = var.create_udp_security_group_rules != "" ? tobool(var.create_udp_security_group_rules) : true
  tags                            = var.tags != "" ? var.tags : {}
  local_subnets                   = var.local_subnets != "" ? var.local_subnets : []
  inside_subnets                  = var.inside_subnets != "" ? var.inside_subnets : []
  outside_subnets                 = var.outside_subnets != "" ? var.outside_subnets : []
  vnet_cidr                       = var.vnet_cidr != "" ? var.vnet_cidr : null
  disable_bgp_route_propagation   = var.disable_bgp_route_propagation != "" ? tobool(var.disable_bgp_route_propagation) : false
}