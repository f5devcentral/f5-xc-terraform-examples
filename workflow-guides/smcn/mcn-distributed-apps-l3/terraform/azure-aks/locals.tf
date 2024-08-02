locals {
  name = ("" != var.prefix) ? format("%s-%s", var.prefix, var.name) : var.name
  azureLocation = var.azure_rg_location
  resourceGroup =  var.azure_rg_name
  node_subnet_id = var.node_subnet_id
  resourceGroupId = ("" != var.azure_rg_id) ? var.azure_rg_id : data.azurerm_resource_group.rg[0].id
  # resourceGroup = data.tfe_outputs.azure.values.resourceGroup
  # resourceOwner = data.tfe_outputs.root.values.resourceOwner
  # projectPrefix = data.tfe_outputs.root.values.projectPrefix
  # buildSuffix = data.tfe_outputs.root.values.buildSuffix
  # vnetName = data.tfe_outputs.azure.values.vnetName
  # xc_tenant = data.tfe_outputs.root.values.xc_tenant
  # namespace = data.tfe_outputs.root.values.namespace
  # f5xcCloudCredAzure = data.tfe_outputs.root.values.f5xcCloudCredAzure
  # azureLocation = data.tfe_outputs.root.values.azureLocation
}