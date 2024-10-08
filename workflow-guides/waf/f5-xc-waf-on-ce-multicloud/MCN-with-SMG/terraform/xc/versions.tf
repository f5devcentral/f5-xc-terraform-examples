terraform {
  required_version = ">= 0.14.0"  
  required_providers {
    volterra = {
      source = "volterraedge/volterra"
      version = ">= 0.11.34"
    }

    google = {
      source  = "hashicorp/google"
      version = "4.27.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.18.0"
    }
  }
}
