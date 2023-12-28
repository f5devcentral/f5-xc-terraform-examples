terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0"
    }
    volterra = {
      source  = "volterraedge/volterra"
      version = ">=0.11.27"
    }
  }
}
