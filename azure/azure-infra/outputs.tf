output "azure_region" {
  value       = var.azure_region
  description = "Azure Region"
}

output "resource_group_name" {
  value       = azurerm_resource_group.rg.name 
  description = "Azure Resource Group Name"
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name 
  description = "Azure Virtual Network Name"
}

output "subnet_name" {
  value       = azurerm_subnet.ce_waap_az_subnet.name
  description = "Azure Subnet Name"
}

output "subnet_id" {
  value       = azurerm_subnet.ce_waap_az_subnet.id
  description = "Azure Subnet ID"
}

output "project_prefix" {
  value = var.project_prefix
}

output "build_suffix" {
  value = random_id.build_suffix.hex
}

output "nap" {
  value = var.nap
}
output "nic" {
  value = var.nic
}
output "bigip" {
  value = var.bigip
}
output "bigip-cis" {
  value = var.bigip-cis
}
output "aks-cluster" {
  value = var.aks-cluster
}
output "azure-vm" {
  value = var.azure-vm
}
output "vm_public_ip" {
  value = var.vm_public_ip
}
output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}