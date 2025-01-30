provider "volterra" {
    url                   = var.api_url
}

provider "google" {
  project                 = local.gcp_project_id
  region                  = local.gcp_region
  credentials             = var.GOOGLE_CREDENTIALS
}

provider "kubernetes" {
  alias                   = "aks"
  host                    = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
  username                = data.azurerm_kubernetes_cluster.aks.kube_config[0].username
  password                = data.azurerm_kubernetes_cluster.aks.kube_config[0].password
  client_certificate      = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
  client_key              = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
  cluster_ca_certificate  = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
}

provider "kubernetes" {
  alias                   = "gke"
  host                    = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token                   = data.google_client_config.provider.access_token
  cluster_ca_certificate  = base64decode(
    data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
  )
}

provider "azurerm" {
  features {}
  subscription_id        = "${var.azure_subscription_id}"
  tenant_id              = "${var.azure_subscription_tenant_id}"
  client_id              = "${var.azure_service_principal_appid}"
  client_secret          = "${var.azure_service_principal_password}"
}

