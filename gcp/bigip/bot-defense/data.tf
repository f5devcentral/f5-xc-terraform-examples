data "tfe_outputs" "bigip" {
  organization    = var.tf_cloud_organization
  workspace       = "bigip"
}

data "tfe_outputs" "f5-air" {
  organization    = var.tf_cloud_organization
  workspace       = "f5air"
}
