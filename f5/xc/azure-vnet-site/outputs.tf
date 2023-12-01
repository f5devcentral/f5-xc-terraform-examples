output "name" {
  description = "Name of the configured Azure VNET Site."
  value       = module.azure_vnet_site.name
}

output "id" {
  description = "ID of the configured Azure VNET Site."
  value       = module.azure_vnet_site.id
}

output "ssh_private_key_pem" {
  description = "Azure VNET Site generated private key."
  value       = module.azure_vnet_site.ssh_private_key_pem
  sensitive   = true
}

output "ssh_private_key_openssh" {
  description = "Azure VNET Site generated OpenSSH private key."
  value       = module.azure_vnet_site.ssh_private_key_openssh
  sensitive   = true
}

output "ssh_public_key" {
  description = "Azure VNET Site public key."
  value       = module.azure_vnet_site.ssh_public_key
}

output "apply_tf_output" {
  description = "Azure VNET Site apply terraform output parameter."
  value       = module.azure_vnet_site.apply_tf_output
}

output "apply_tf_output_map" {
  description = "Azure VNET Site apply terraform output parameter."
  value       = module.azure_vnet_site.apply_tf_output_map
}

output "master_nodes_az_names" {
  description = "Azure VNET Site master nodes availability zone names."
  value       = module.azure_vnet_site.master_nodes_az_names
}

output "vnet_resource_group" {
  description = "Azure VNET resource group name."
  value       = module.azure_vnet_site.vnet_resource_group
}

output "vnet_name" {
  description = "Azure VNET name."
  value       = module.azure_vnet_site.vnet_name
}


output "inside_rt_names" {
  description = "Azure VNET inside route table name."
  value       =  module.azure_vnet_site.inside_rt_names
}

output "location" {
  description = "Azure Resources Location."
  value       = module.azure_vnet_site.location
}

output "site_resource_group" {
  description = "Azure VNET Site resource group name."
  value       = module.azure_vnet_site.site_resource_group
}

output "sli_nic_ids" {
  description = "Azure VNET Site SLI NIC IDs."
  value       = module.azure_vnet_site.sli_nic_ids
}

output "sli_nic_names" {
  description = "Azure VNET Site SLI NIC names."
  value       = module.azure_vnet_site.sli_nic_names
}

output "sli_nic_private_ips" {
  description = "Azure VNET Site SLI NIC private IPs."
  value       = module.azure_vnet_site.sli_nic_private_ips
}

output "slo_nic_ids" {
  description = "Azure VNET Site SLO NIC IDs."
  value       = module.azure_vnet_site.slo_nic_ids
}

output "slo_nic_names" {
  description = "Azure VNET Site SLO NIC names."
  value       = module.azure_vnet_site.slo_nic_names
}

output "slo_nic_private_ips" {
  description = "Azure VNET Site SLO NIC private IPs."
  value       = module.azure_vnet_site.slo_nic_private_ips
}

output "slo_nic_public_ips" {
  description = "Azure VNET Site SLO NIC public IPs."
  value       = module.azure_vnet_site.slo_nic_public_ips
}