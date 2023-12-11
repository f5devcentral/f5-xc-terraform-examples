

data "template_file" "az_init_script" {
  template = file("init-script.tpl")
  vars = {
    workload_name = format("AZURE-%s", local.workload_name)
  }
}

data "azurerm_subnet" "inside" {
  count = length(var.azure_inside_subnet_names) > 0 ? 1 : 0
  name                 = element(var.azure_inside_subnet_names, 0)
  virtual_network_name = var.azure_vnet_name
  resource_group_name  = var.azure_rg_name
}

resource "azurerm_network_interface" "nic" {
  name                = format("%s-nic", local.workload_name)
  location            = var.azure_rg_location
  resource_group_name = var.azure_rg_name

  ip_configuration {
    name                          = "inside-subnet"
    subnet_id                     = try(data.azurerm_subnet.inside[0].id, null)
    private_ip_address_allocation = "Static"
    private_ip_address            = var.azure_vm_private_ip
    public_ip_address_id          = azurerm_public_ip.ip.id
  }

  depends_on = [
    azurerm_public_ip.ip
  ]
}

resource "azurerm_network_security_group" "nsg" {
  name                = format("%s-nsg", local.workload_name)
  location            = var.azure_rg_location
  resource_group_name = var.azure_rg_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_public_ip" "ip" {
  name                = format("%s-ip", local.workload_name)
  location            = var.azure_rg_location
  resource_group_name = var.azure_rg_name
  allocation_method   = "Static"
}

resource "azurerm_linux_virtual_machine" "test-vm" {
  name                  = format("%s-vm", local.workload_name)
  location              = var.azure_rg_location
  resource_group_name   = var.azure_rg_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_DS1_v2"
  admin_username        = "ubuntu"

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "ubuntu"
    public_key = tls_private_key.key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  user_data = base64encode(data.template_file.az_init_script.rendered)
}