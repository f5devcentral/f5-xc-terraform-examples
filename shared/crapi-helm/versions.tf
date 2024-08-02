terraform {
  required_version = ">= 0.14.0"
  required_providers {
    aws = ">= 4"
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.14.0"
    }
  }
}