terraform {
  required_version = ">= 1.0"

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">=0.11.44"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.40.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=3.5.0"
    }
  }
}
