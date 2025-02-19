data "tfe_outputs" "azure-infra" {
  organization = var.tf_cloud_organization
  workspace = "azure-infra"
}
data "azurerm_resources" "vnet" {
  count = var.use_existing_vnet ? 0 : 1
  type                = "Microsoft.Network/virtualNetworks"
  resource_group_name = local.aks_resource_group_name
  depends_on = [azurerm_kubernetes_cluster.ce_waap]
}
data "azurerm_lb" "lb" {
  count = var.use_existing_vnet ? 0 : 1
  name = "kubernetes-internal"
  resource_group_name = local.aks_resource_group_name
  depends_on = [time_sleep.wait_10_seconds]
}
data "azurerm_virtual_network" "aks-vnet"{
  count = var.use_existing_vnet ? 0 : 1
  name                = data.azurerm_resources.vnet[0].resources[0].name
  resource_group_name = local.aks_resource_group_name
}
data "azurerm_subnet" "aks-subnet" {
  count = var.use_existing_vnet ? 0 : 1
  name                 = data.azurerm_virtual_network.aks-vnet[0].subnets[0]
  resource_group_name  = local.aks_resource_group_name
  virtual_network_name = data.azurerm_resources.vnet[0].resources[0].name
}