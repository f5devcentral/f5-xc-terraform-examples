output "vnet_name" {
  value       = module.xc_azure_vnet.vnet_name
  description = "The name of the VNET."
}

output "location" {
  value       = module.xc_azure_vnet.location
  description = "The location/region where the VNET."
}

output "resource_group_name" {
  value       = module.xc_azure_vnet.resource_group_name
  description = "The name of the resource group."
}

output "vnet_id" {
  value       = module.xc_azure_vnet.vnet_id
  description = "The ID of the VNET."
}

output "vnet_cidr" {
  value       = module.xc_azure_vnet.vnet_cidr
  description = "The CIDR block of the VNET."
}

output "outside_subnet_ids" {
  value       = module.xc_azure_vnet.outside_subnet_ids
  description = "The IDs of the outside subnets."
}

output "inside_subnet_ids" {
  value       = module.xc_azure_vnet.inside_subnet_ids
  description = "The IDs of the inside subnets."
}

output "local_subnet_ids" {
  value       = module.xc_azure_vnet.local_subnet_ids
  description = "The IDs of the local subnets."
}

output "outside_subnet_names" {
  value       = module.xc_azure_vnet.outside_subnet_names
  description = "The Names of the outside subnets."
}

output "inside_subnet_names" {
  value       = module.xc_azure_vnet.inside_subnet_names
  description = "The Names of the inside subnets."
}

output "local_subnet_names" {
  value       = module.xc_azure_vnet.local_subnet_names
  description = "The Names of the local subnets."
}

output "inside_route_table_ids" {
  value       = module.xc_azure_vnet.inside_route_table_ids
  description = "The IDs of the inside route tables."
}

output "inside_route_table_names" {
  value       = module.xc_azure_vnet.inside_route_table_names
  description = "The names of the inside route tables."
}

output "outside_security_group_name" {
  value       = module.xc_azure_vnet.outside_security_group_name
  description = "The Name of the outside security group."
}

output "inside_security_group_name" {
  value       = module.xc_azure_vnet.inside_security_group_name
  description = "The Name of the inside security group."
}

output "az_names" {
  value       = module.xc_azure_vnet.az_names
  description = "Availability zones."
}