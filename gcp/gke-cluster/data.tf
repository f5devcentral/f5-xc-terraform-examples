data "tfe_outputs" "gcp-infra" {
  organization = var.tf_cloud_organization
  workspace = "gcp_infra"
}
