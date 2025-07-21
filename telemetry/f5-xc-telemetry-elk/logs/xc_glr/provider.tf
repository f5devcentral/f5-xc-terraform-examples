terraform {
  required_version = ">= 0.14.0"  
  required_providers {
    volterra = {
      source = "volterraedge/volterra"
      version = "= 0.11.32"
    }
  }
}

provider "volterra" {
    api_p12_file     = var.api_p12
    url   = var.xc_url
}