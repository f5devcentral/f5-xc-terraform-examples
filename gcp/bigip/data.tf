data "tfe_outputs" "gcp-infra" {
  organization  = var.tf_cloud_organization
  workspace     = "gcp-infra"
}

data "tfe_outputs" "f5-air" {
  organization    = var.tf_cloud_organization
  workspace       = "f5air"
}
