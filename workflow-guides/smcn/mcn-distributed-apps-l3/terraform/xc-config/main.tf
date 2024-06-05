terraform {
  required_version = ">= 1.2"
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.18"
    }
  }
}

provider "volterra" {
  api_p12_file = var.xc_api_p12_file
  url          = var.xc_api_url
}