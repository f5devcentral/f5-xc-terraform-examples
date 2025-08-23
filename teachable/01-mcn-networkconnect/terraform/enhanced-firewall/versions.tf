terraform {
  required_version = ">= 1.0"

  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = ">=4.1.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">=2.5.3"
    }
    template = {
      source  = "hashicorp/template"
      version = ">=2.2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">=6.9.0"
    }
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
