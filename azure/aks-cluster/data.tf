data "tfe_outputs" "azure-infra" {
  organization = var.tf_cloud_organization
  workspace = "azure-infra"
}
data "azurerm_resources" "vnet" {
  for_each = var.use_existing_vnet ? [] : [1]
  type                = "Microsoft.Network/virtualNetworks"
  resource_group_name = local.aks_resource_group_name
  depends_on = [azurerm_kubernetes_cluster.ce_waap]
}
data "azurerm_lb" "lb" {
  for_each = var.use_existing_vnet ? [] : [1]
  name = "kubernetes-internal"
  resource_group_name = local.aks_resource_group_name
  depends_on = [time_sleep.wait_10_seconds]
}
data "azurerm_virtual_network" "aks-vnet"{
  for_each = var.use_existing_vnet ? [] : [1]
  name                = data.azurerm_resources.vnet.resources[0].name
  resource_group_name = local.aks_resource_group_name
}
data "azurerm_subnet" "aks-subnet" {
  for_each = var.use_existing_vnet ? [] : [1]
  name                 = data.azurerm_virtual_network.aks-vnet.subnets[0]
  resource_group_name  = local.aks_resource_group_name
  virtual_network_name = data.azurerm_resources.vnet.resources[0].name
}