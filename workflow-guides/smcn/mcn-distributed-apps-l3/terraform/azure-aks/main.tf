########################### Providers ##########################

terraform {
  required_version = "~> 1.0"

  required_providers {
    azurerm = ">= 3.73.0"
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"

  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
}