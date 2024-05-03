locals {
  name         = ("" != var.prefix) ? format("%s-%s", var.prefix, var.name) : var.name
  resourceOwner = var.resource_owner
  commonLabels = {
    demo   = ("" != var.prefix) ? format("%s-%s", var.prefix, var.name) : var.name
    owner  = var.resource_owner
  }

  azure_vnet_cidr     = var.azure_vnet_cidr
  gcp_vnet_cidr       = var.gcp_vnet_cidr
  gcp_vnet_proxy_cird = var.gcp_vnet_proxy_cird
  aws_vpc_cidr        = var.aws_vpc_cidr
}

