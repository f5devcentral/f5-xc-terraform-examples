output "client_certificate" {
  value     = azurerm_kubernetes_cluster.ce_waap.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.ce_waap.kube_config_raw
  sensitive = true
}
output "cluster_name" {
  value = azurerm_kubernetes_cluster.ce_waap.name
  sensitive = true
}
output "cluster_id" {
  value = azurerm_kubernetes_cluster.ce_waap.id
  sensitive = true
}
output "app_external_ip" {
  value = var.use_new_vnet ? data.azurerm_lb.lb[0].private_ip_address : null
}
output "azure_aks_resource_group_name" {
  value = format("MC_%s-rg-%s_%s-aks-%s_%s", local.project_prefix, local.build_suffix,local.project_prefix, local.build_suffix,local.azure_region)
  sensitive = true
}
output "aks_vnet_name" {
  value = var.use_new_vnet ? data.azurerm_resources.vnet[0].resources[0].name : null
}
output "aks_vnet_id" {
  value = var.use_new_vnet ? data.azurerm_resources.vnet[0].resources[0].id : null
}
output "aks_subnet_name" {
  value = var.use_new_vnet ? data.azurerm_virtual_network.aks-vnet[0].subnets[0] : null
}
output "aks_subnet_id" {
  value = var.use_new_vnet ? data.azurerm_subnet.aks-subnet[0].id : null
}