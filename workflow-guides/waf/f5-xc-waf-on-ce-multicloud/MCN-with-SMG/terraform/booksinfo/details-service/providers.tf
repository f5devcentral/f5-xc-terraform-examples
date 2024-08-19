provider "azurerm" {
  features {}
  subscription_id   = "${var.azure_subscription_id}"
  tenant_id         = "${var.azure_subscription_tenant_id}"
  client_id         = "${var.azure_service_principal_appid}"
  client_secret     = "${var.azure_service_principal_password}"
}


provider "kubectl" {
  host                    = data.azurerm_kubernetes_cluster.aks.kube_config.0.host
  client_certificate      = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key              = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate  = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  load_config_file        = false
}
