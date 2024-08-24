terraform {
  required_version = ">= 0.14.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.16.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.76.0"
    }
  }
}