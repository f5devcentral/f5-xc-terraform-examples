data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organization
  workspace = "infra"
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
data "azurerm_virtual_machine" "az-ce-site" {
  count               = var.az_ce_site ? 1 : 0
  depends_on          = [volterra_tf_params_action.action_apply]
  name                = "master-0"
  resource_group_name = format("%s-rg-xc-%s", local.project_prefix, local.build_suffix)
}

data "tfe_outputs" "gcp-vm" {
  organization = var.tf_cloud_organization
  workspace    = "bookinfo"
}
