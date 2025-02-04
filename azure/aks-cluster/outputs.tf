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
output "node_details" {
  value = azurerm_kubernetes_cluster.ce_waap.default_node_pool.node_network_profile
}