provider "azurerm" {
  features {}
  count = var.azure ? 1 : 0
  subscription_id   = "${var.azure_subscription_id}"
  tenant_id         = "${var.azure_subscription_tenant_id}"
  client_id         = "${var.azure_service_principal_appid}"
  client_secret     = "${var.azure_service_principal_password}"
}

provider "volterra" {
    url   = var.api_url
}
