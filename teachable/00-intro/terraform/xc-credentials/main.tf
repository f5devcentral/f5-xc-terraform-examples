provider "volterra" {
  api_p12_file = var.xc_api_p12_file
  url          = var.xc_api_url
}

data volterra_namespace "this" {
  name = "default"
}