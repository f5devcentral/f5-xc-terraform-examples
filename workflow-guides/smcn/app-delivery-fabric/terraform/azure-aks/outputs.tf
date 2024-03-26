output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks-cluster.kube_config.0.client_certificate
  sensitive = true
}

output "client_key" {
  value     = azurerm_kubernetes_cluster.aks-cluster.kube_config.0.client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.aks-cluster.kube_config.0.cluster_ca_certificate
  sensitive = true
}

output "kubeconfig_raw" {
  value = nonsensitive(azurerm_kubernetes_cluster.aks-cluster.kube_config_raw)
}

output "cluster_endpoint" {
  value = format("https://%s", azurerm_kubernetes_cluster.aks-cluster.fqdn)
}

output "cluster_name" {
  value = nonsensitive(azurerm_kubernetes_cluster.aks-cluster.name)
}