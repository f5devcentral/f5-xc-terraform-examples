data "tfe_outputs" "azure-infra" {
  organization = var.tf_cloud_organization
  workspace = "azure-infra"
}
data "azurerm_resources" "vnet" {
  type                = "Microsoft.Network/virtualNetworks"
  resource_group_name = format("MC_%s-rg-%s_%s-aks-%s_%s", local.project_prefix, local.build_suffix,local.project_prefix, local.build_suffix,local.azure_region)
  depends_on = [azurerm_kubernetes_cluster.ce_waap]
}
data "azurerm_lb" "lb" {
  name = "kubernetes-internal"
  resource_group_name = format("MC_%s-rg-%s_%s-aks-%s_%s", local.project_prefix, local.build_suffix,local.project_prefix, local.build_suffix,local.azure_region)
  depends_on = [time_sleep.wait_10_seconds]
}
