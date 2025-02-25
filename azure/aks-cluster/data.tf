data "tfe_outputs" "azure-infra" {
  organization = var.tf_cloud_organization
  workspace = "azure-infra"
}
# Fetch AKS created Vnet
data "azurerm_resources" "vnet" {
  count = var.use_new_vnet ? 1 : 0
  type                = "Microsoft.Network/virtualNetworks"
  resource_group_name = local.aks_resource_group_name
  depends_on = [azurerm_kubernetes_cluster.ce_waap]
}
# Fetch Loadbalancer External IP address
data "azurerm_lb" "lb" {
  count = var.use_new_vnet ? 1 : 0
  name = "kubernetes-internal"
  resource_group_name = local.aks_resource_group_name
  depends_on = [time_sleep.wait_30_seconds]
}
# Fetch AKS created Vnet details
data "azurerm_virtual_network" "aks-vnet"{
  count = var.use_new_vnet ? 1 : 0
  name                = data.azurerm_resources.vnet[0].resources[0].name
  resource_group_name = local.aks_resource_group_name
}
# Fetch AKS created subnet details
data "azurerm_subnet" "aks-subnet" {
  count = var.use_new_vnet ? 1 : 0
  name                 = data.azurerm_virtual_network.aks-vnet[0].subnets[0]
  resource_group_name  = local.aks_resource_group_name
  virtual_network_name = data.azurerm_resources.vnet[0].resources[0].name
}