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
}
output "cluster_id" {
  value = azurerm_kubernetes_cluster.ce_waap.id
}