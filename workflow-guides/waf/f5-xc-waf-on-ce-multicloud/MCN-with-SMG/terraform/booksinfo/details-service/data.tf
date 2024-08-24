data "tfe_outputs" "azure-infra" {
  organization              = var.tf_cloud_organization
  workspace                 = "azure-infra"
}

data "azurerm_kubernetes_cluster" "aks" {
	name 					= format("%s-aks-%s", local.project_prefix, local.build_suffix)
	resource_group_name   	= local.resource_group_name
}