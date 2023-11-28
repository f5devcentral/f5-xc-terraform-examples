resource "azurerm_network_interface" "nic" {
  name                = "waap-nic"
  location            = local.azure_region
  resource_group_name = local.resource_group_name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = local.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.puip.id

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
    name                       = "ssh"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
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

  provisioner "file" {
    source      = "default.conf"
    destination = "/home/Demouser/default.conf"

    connection {
      type     = "ssh"
      user     = "Demouser"
      password = "Demouser1234"
      agent    = false
      host     = azurerm_linux_virtual_machine.vm_inst.public_ip_address
    }
  }
}

resource "azurerm_public_ip" "puip" {
  name                = "waf-public-ip"
  location            = local.azure_region
  resource_group_name = local.resource_group_name
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

resource "azurerm_network_interface_security_group_association" "securitygroup" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}