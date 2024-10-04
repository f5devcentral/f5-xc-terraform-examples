resource "azurerm_ssh_public_key" "f5_key" {
  name                = format("%s-pubkey-%s", local.project_prefix, local.build_suffix)
  resource_group_name = local.resource_group_name
  location            = local.azure_region
  public_key          = file("~/.ssh/id_rsa.pub")
}

module "bigip" {
  count                       = 1
  source                      = "F5Networks/bigip-module/azure"
  prefix                      = local.project_prefix
  resource_group_name         = local.resource_group_name
  f5_ssh_publickey            = azurerm_ssh_public_key.f5_key.public_key
  mgmt_subnet_ids             = [{ "subnet_id" = local.subnet_id, "public_ip" = true, "private_ip_primary" = "" }]
  mgmt_securitygroup_ids      = [module.mgmt-network-security-group.network_security_group_id]
#  availability_zone           = var.availability_zone
#  availabilityZones_public_ip = var.availabilityZones_public_ip
}

#resource "null_resource" "clusterDO" {
#
#  count = 1
#
#  provisioner "local-exec" {
#    command = "cat > DO_1nic-instance${count.index}.json <<EOL\n ${module.bigip[count.index].onboard_do}\nEOL"
#  }
#  provisioner "local-exec" {
#    when    = destroy
#    command = "rm -rf DO_1nic-instance${count.index}.json"
#  }
#  depends_on = [module.bigip.onboard_do]
#}

module "mgmt-network-security-group" {
  source              = "Azure/network-security-group/azurerm"
  resource_group_name = local.resource_group_name
  security_group_name = format("%s-mgmt-nsg-%s", local.project_prefix, local.build_suffix)

}

resource "azurerm_network_security_rule" "mgmt_allow_rules" {
  name                        = "Allow_Rules"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges      = ["8443","443","80","22"]
  destination_address_prefix  = "*"
  source_address_prefixes     = ["0.0.0.0/0"]
  resource_group_name         = local.resource_group_name
  network_security_group_name = format("%s-mgmt-nsg-%s", local.project_prefix, local.build_suffix)
  depends_on                  = [module.mgmt-network-security-group]
}