resource "azurerm_resource_group" "rg" {
  name     = format("%s-rg-%s", var.project_prefix, random_id.build_suffix.hex)
  location = var.azure_region
}

resource "azurerm_virtual_network" "vnet" {
  name                = format("%s-vnet-%s", var.project_prefix, random_id.build_suffix.hex)
  address_space       = var.azure_vnet_cidr
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "ce_waap_az_subnet" {
  name                 = format("%s-subnet-%s", var.project_prefix, random_id.build_suffix.hex)
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.azure_subnet_cidr
}
