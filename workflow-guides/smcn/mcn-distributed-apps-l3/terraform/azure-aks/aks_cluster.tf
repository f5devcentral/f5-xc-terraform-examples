# Create an AKS cluster with nodes on XC CE's SLO subnet
resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = format("%s-aks-cluster", local.name)
  location            = local.azureLocation
  resource_group_name = local.resourceGroup
  dns_prefix          = "xc-aks"

  network_profile {
    network_plugin = "azure"
    // UDR for custom route table entries to access internal remote sites and outbound NAT
    outbound_type = "userDefinedRouting"
  }
  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id = local.node_subnet_id
    // pod_subnet_id = data.azurerm_subnet.pods.id
    // temporary_name_for_rotation = local.buildSuffix
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

# Grant Network Contributor access to allow it to create an internal LB
resource "azurerm_role_assignment" "system-managed-kubelet" {
  scope = local.resourceGroupId
  role_definition_name = "Network Contributor"
  principal_id = azurerm_kubernetes_cluster.aks-cluster.kubelet_identity[0].object_id
}
resource "azurerm_role_assignment" "system-managed-aks-cluster" {
  scope = local.resourceGroupId
  role_definition_name = "Network Contributor"
  principal_id = azurerm_kubernetes_cluster.aks-cluster.identity[0].principal_id
}