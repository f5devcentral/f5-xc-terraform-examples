locals {
  name = var.prefix != "" ? format("%s-%s", var.prefix, var.name) : var.name
}

module "xc_azure_vnet" {
  source  = "f5devcentral/azure-vnet-site-networking/xc"
  version = "0.0.4"

  name                            = local.name
  location                        = var.location
  resource_group_name             = var.resource_group_name != "" ? var.resource_group_name : local.name
  create_vnet                     = var.create_vnet != "" ? tobool(var.create_vnet) : true
  create_resource_group           = var.create_resource_group != "" ? tobool(var.create_resource_group) : true
  create_outside_security_group   = var.create_outside_security_group != "" ? tobool(var.create_outside_security_group) : true
  create_inside_route_table       = var.create_inside_route_table != "" ? tobool(var.create_inside_route_table) : true
  create_inside_security_group    = var.create_inside_security_group != "" ? tobool(var.create_inside_security_group) : true
  tags                            = var.tags != "" ? var.tags : {}
  local_subnets                   = var.local_subnets != "" ? var.local_subnets : []
  inside_subnets                  = var.inside_subnets != "" ? var.inside_subnets : []
  outside_subnets                 = var.outside_subnets != "" ? var.outside_subnets : []
  vnet_cidr                       = var.vnet_cidr != "" ? var.vnet_cidr : null
  bgp_route_propagation_enabled   = var.bgp_route_propagation_enabled != "" ? tobool(var.bgp_route_propagation_enabled) : true
}
