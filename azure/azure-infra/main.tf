provider "azurerm" {
  features {}
  subscription_id   = "${var.azure_subscription_id}"
  tenant_id         = "${var.azure_subscription_tenant_id}"
  client_id         = "${var.azure_service_principal_appid}"
  client_secret     = "${var.azure_service_principal_password}"
}

# Create a random id
resource "random_id" "build_suffix" {
  byte_length = 2
}
