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
  value = data.azurerm_lb.lb.private_ip_address
}
output "azure_aks_resource_group_name" {
  value = format("MC_%s-rg-%s_%s-aks-%s_%s", local.project_prefix, local.build_suffix,local.project_prefix, local.build_suffix,local.azure_region)
}
