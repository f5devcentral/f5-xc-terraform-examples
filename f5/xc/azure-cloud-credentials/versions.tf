terraform {
  required_version = ">= 1.0"

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">=0.11.26"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.44.0"
    }
  }
}
