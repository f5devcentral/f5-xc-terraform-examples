terraform {
  required_version = ">= 0.14.0"
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.26"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.16.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.7.0" 
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=3.76.0"
    }
  }
}