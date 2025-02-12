resource "azurerm_kubernetes_cluster" "ce_waap" {
  name                = format("%s-aks-%s", local.project_prefix, local.build_suffix)
  location            = local.azure_region
  resource_group_name = local.resource_group_name
  dns_prefix          = format("%s-aks-dns-%s", local.project_prefix, local.build_suffix)
  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "Standard_D2_v2"
    vnet_subnet_id      = var.user_existing_vnet ? local.subnet_id : null
    auto_scaling_enabled= false
    # below field is renamed in latest resource version
    # enable_auto_scaling = false
  }
	
  identity {
    type = "SystemAssigned"
  }

  network_profile {
	network_plugin = "azure"
  }
}
data "azurerm_resources" "vnet" {
  type                = "Microsoft.Network/virtualNetworks"
  resource_group_name = azurerm_kubernetes_cluster.ce_waap.node_resource_group
  depends_on = [azurerm_kubernetes_cluster.ce_waap]
}

resource "azurerm_virtual_network_peering" "peer_a2b" {
  name                         = "peer-vnet-a-with-b"
  resource_group_name          = local.resource_group_name
  virtual_network_name         = local.vnet_name
  remote_virtual_network_id    = data.azurerm_resources.vnet.resources[0].id
  allow_virtual_network_access = true
  depends_on = [data.azurerm_resources.vnet]
}
# Azure Virtual Network peering between Virtual Network B and A
resource "azurerm_virtual_network_peering" "peer_b2a" {
  name                         = "peer-vnet-b-with-a"
  resource_group_name          = azurerm_kubernetes_cluster.ce_waap.node_resource_group
  virtual_network_name         = data.azurerm_resources.vnet.resources[0].name
  remote_virtual_network_id    = local.vnet_id
  allow_virtual_network_access = true
  depends_on                   = [azurerm_virtual_network_peering.peer_a2b]
}

resource "local_file" "kubeconfig" {
  depends_on   = [azurerm_virtual_network_peering.peer_b2a]
  filename     = "./kubeconfig"
  content      = azurerm_kubernetes_cluster.ce_waap.kube_config_raw
}

resource "null_resource" "deploy-yaml" {
  depends_on  = [local_file.kubeconfig]
  provisioner "local-exec" {
    command = "curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl"
  }
  provisioner "local-exec" {
      command = "./kubectl apply -f manifest.yaml"
      environment = {
      		KUBECONFIG = "./kubeconfig"
    }
  }
}