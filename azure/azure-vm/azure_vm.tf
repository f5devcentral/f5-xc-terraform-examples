resource "azurerm_network_interface" "nic" {
  name                = "waap-nic"
  location            = local.azure_region
  resource_group_name = local.resource_group_name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = local.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = local.vm_public_ip ? azurerm_public_ip.puip[0].id : null
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "waap-nsg"
  location            = local.azure_region
  resource_group_name = local.resource_group_name
  security_rule {
    name                       = "arcadia"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "http"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_linux_virtual_machine" "vm_inst" {
  count = local.vm_public_ip ? 1 : 0
  name                = "waf-re-vm"
  resource_group_name = local.resource_group_name
  location            = local.azure_region
  size                = "Standard_F2"
  admin_username      = "Demouser"
  admin_password      = "Demouser1234"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  plan {
    name       = "nginx_plus_with_nginx_app_protect_prem_ubuntu2004"
    product    = "nginx_plus_with_nginx_app_protect_premium"
    publisher  = "nginxinc"
  }
  source_image_reference {
    publisher = "nginxinc"
    offer     = "nginx_plus_with_nginx_app_protect_premium"
    sku       = "nginx_plus_with_nginx_app_protect_prem_ubuntu2004"
    version   = "latest"
  }
  user_data = filebase64("./userdata.txt")
}

resource "azurerm_public_ip" "puip" {
  count = local.vm_public_ip ? 1 : 0
  name                = "waf-public-ip"
  location            = local.azure_region
  resource_group_name = local.resource_group_name
  sku                 = "Basic"
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "public" {
  name                = "waf-nic-public"
  location            = local.azure_region
  resource_group_name = local.resource_group_name
  ip_configuration {
    name                          = "public"
    subnet_id                     = local.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm_inst_private" {
  count                           = local.vm_public_ip ? 0 : 1
  name                            = "vm-waf-demo"
  resource_group_name             = local.resource_group_name
  location                        = local.azure_region
  size                            = "Standard_F2"
  admin_username                  = "Demouser"
  admin_password                  = "Demouser@1234"
  disable_password_authentication = false
  network_interface_ids           = [
    azurerm_network_interface.nic.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  user_data = filebase64("./dvwa_userdata.txt")
}

resource "azurerm_network_interface_security_group_association" "securitygroup" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

