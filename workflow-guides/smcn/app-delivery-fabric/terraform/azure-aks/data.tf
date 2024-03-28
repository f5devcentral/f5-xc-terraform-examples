data "azurerm_resource_group" "rg" {
  count = var.azure_rg_id == "" ? 1 : 0
  
  name  = local.resourceGroup
}
