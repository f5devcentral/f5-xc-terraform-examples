variable "tf_cloud_organization" {
  type = string
  description = "TF cloud org (Value set in TF cloud)"
}

data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organization
  workspace = "infra"
}
