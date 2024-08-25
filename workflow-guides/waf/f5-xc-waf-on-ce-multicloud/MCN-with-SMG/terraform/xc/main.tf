provider "volterra" {
    url   = var.api_url
}

provider "google" {
  project = local.gcp_project_id
  region  = local.gcp_region
}

provider "azurerm" {
  features {}
  subscription_id   = "${var.azure_subscription_id}"
  tenant_id         = "${var.azure_subscription_tenant_id}"
  client_id         = "${var.azure_service_principal_appid}"
  client_secret     = "${var.azure_service_principal_password}"
}