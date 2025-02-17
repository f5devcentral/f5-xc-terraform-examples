terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.18.0"
    }
     time = {
      source = "hashicorp/time"
      version = "0.12.1"
    }
  }
}
