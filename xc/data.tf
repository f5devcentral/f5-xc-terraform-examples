data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organization
  workspace = "${coalesce(var.aws, var.azure, var.gcp, "infra")}"
}

data "tfe_outputs" "bigip" {
  count = data.tfe_outputs.infra.values.bigip ? 1 : 0
  organization = var.tf_cloud_organization
  workspace = "bigip-base"
}
data "tfe_outputs" "nap" {
  count = data.tfe_outputs.infra.values.nap ? 1 : 0
  organization = var.tf_cloud_organization
  workspace = "nap"
}
data "tfe_outputs" "nic" {
  count = data.tfe_outputs.infra.values.nic ? 1 : 0
  organization = var.tf_cloud_organization
  workspace = "nic"
}
data "tfe_outputs" "aks-cluster" {
  count = data.tfe_outputs.infra.values.aks-cluster ? 1 : 0 
  organization = var.tf_cloud_organization
  workspace = "aks-cluster"
}
data "tfe_outputs" "azure-vm" {
  count = data.tfe_outputs.infra.values.azure-vm ? 1 : 0 
  organization = var.tf_cloud_organization
  workspace = "azure-vm"
}
data "tfe_outputs" "gcp-vm" {
  count        = var.gcp_ce_site ? 1 : 0
  organization = var.tf_cloud_organization
  workspace    = "juiceshop"
}
data "tfe_outputs" "eks" {
  count               = var.eks_ce_site ? 1 : 0
  organization        = var.tf_cloud_organization
  workspace           = "eks"
}
data "tfe_outputs" "aws_eks_cluster" {
  count               = var.aws_ce_site ? 1 : 0
  organization        = var.tf_cloud_organization
  workspace           = "aws_eks_cluster"
}
data "tfe_outputs" "app-deploy" {
  count               = var.aws_ce_site ? 1 : 0
  organization        = var.tf_cloud_organization
  workspace           = "boutique_app"
}
