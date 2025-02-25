data "tfe_outputs" "azure-infra" {
  organization  = var.tf_cloud_organization
  workspace     = "azure-infra"
}

data "tfe_outputs" "aks-cluster" {
  organization = var.tf_cloud_organization
  workspace = "aks-cluster"
}
data "tfe_outputs" "bigip" {
  organization    = var.tf_cloud_organization
  workspace       = "bigip"
}