provider "azurerm" {
  features {}
  subscription_id   = "${var.azure_subscription_id}"
  tenant_id         = "${var.azure_subscription_tenant_id}"
  client_id         = "${var.azure_service_principal_appid}"
  client_secret     = "${var.azure_service_principal_password}"
}


provider "kubectl" {
    client_certificate      = base64decode(local.cluster_ca_certificate)
    config_context          = base64decode(local.kubeconfig)
    load_config_file        = false
}
