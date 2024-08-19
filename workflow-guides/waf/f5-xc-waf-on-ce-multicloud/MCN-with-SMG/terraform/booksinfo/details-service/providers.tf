provider "azurerm" {
  features {}
}

#resource "local_file" "kubeconfig" {
#  content   =  local.kubeconfig
#  filename  = "${path.module}/kubeconfig"
#}

provider "kubectl" {
#  host                    = data.azurerm_kubernetes_cluster.aks.kube_config.0.host
#  client_certificate      = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
#  client_key              = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
#  cluster_ca_certificate  = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  config_context           = local.kubeconfig["contexts"][0]["name"]
  load_config_file         = false
}
