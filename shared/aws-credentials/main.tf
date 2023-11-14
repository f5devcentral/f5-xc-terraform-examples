provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_token
}

provider "volterra" {
  api_p12_file = var.xc_api_p12_file
  url          = var.xc_api_url
}

locals {
  aws_site_name = (null != var.prefix) ? format("%s-%s", var.prefix, var.name) : var.name
}