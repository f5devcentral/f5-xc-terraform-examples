terraform {
  required_version = ">= 1.0"

  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = ">=4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">=2.1"
    }
    template = {
      source  = "hashicorp/template"
      version = ">=2.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0"
    }
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
