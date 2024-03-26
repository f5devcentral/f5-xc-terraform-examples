locals {
  name            = ("" != var.prefix) ? format("%s-%s", var.prefix, var.name) : var.name
  azureLocation   = var.azure_rg_location
  resourceGroup   =  var.azure_rg_name
  node_subnet_id  = var.node_subnet_id
  resourceGroupId = ("" != var.azure_rg_id) ? var.azure_rg_id : data.azurerm_resource_group.rg[0].id

  aks_node_count = 1
}