data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organization
  workspace = secrets.TF_CLOUD_WORKSPACE_INFRA
}
