terraform {
  required_version = ">= 0.14.0"  
  required_providers {
    volterra = {
      source = "volterraedge/volterra"
      version = ">= 0.11.29"
    }
      azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.18.0"
    }
  }
}
