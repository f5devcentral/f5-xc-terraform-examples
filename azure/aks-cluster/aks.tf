resource "azurerm_kubernetes_cluster" "ce_waap" {
  name                = format("%s-aks-%s", local.project_prefix, local.build_suffix)
  location            = local.azure_region
  resource_group_name = local.resource_group_name
  dns_prefix          = format("%s-aks-dns-%s", local.project_prefix, local.build_suffix)
  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "Standard_D2_v2"
    vnet_subnet_id      = local.subnet_id
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
#data "azurerm_user_assigned_identity" "aks-identity" {
#  name                = "${azurerm_kubernetes_cluster.kubernetes_cluster[0].name}-agentpool"
#  resource_group_name = "MC_${module.resource_group_kubernetes_cluster[0].name}_aks-prjx-spoke-dev-eastus-001_eastus"
#
#  depends_on          = [module.resource_group_kubernetes_cluster]
#}
#
## Provide ACR Pull permission to AKS SystemAssigned Identity
#resource "azurerm_role_assignment" "acrpull_role" {
#  scope                            = module.container_registry[0].id
#  role_definition_name             = "AcrPull"
#  principal_id                     = data.azurerm_user_assigned_identity.aks-identity.principal_id
#  skip_service_principal_aad_check = true
#
#  depends_on                       = [
#    data.azurerm_user_assigned_identity.aks-identity
#  ]
#}
#
#resource "azurerm_role_assignment" "aks_id_network_contributor_subnet" {
#  scope                = data.azurerm_subnet.aks-subnet.id
#  role_definition_name = "Network Contributor"
#  principal_id         = data.azurerm_user_assigned_identity.aks-identity.principal_id
#
#  depends_on = [data.azurerm_user_assigned_identity.aks-identity]
#}
#
#data "azuread_service_principal" "aks-sp" {
#  display_name  = azurerm_kubernetes_cluster.ce_waap.name
#  depends_on = [azurerm_kubernetes_cluster.ce_waap]
#}
#
#resource "azurerm_role_assignment" "network_contributor_subnet" {
#  scope                = local.subnet_id
#  role_definition_name = "Network Contributor"
#  principal_id         = data.azuread_service_principal.aks-sp.object_id
#
#  depends_on = [data.azuread_service_principal.aks-sp]
#}
resource "azurerm_role_assignment" "owner" {
  principal_id         = azurerm_kubernetes_cluster.ce_waap.identity[0].principal_id
  role_definition_name = "Owner"
  scope                = local.subnet_id
  depends_on = [azurerm_kubernetes_cluster.ce_waap]
}
resource "azurerm_role_assignment" "network-contributor" {
  principal_id         = azurerm_kubernetes_cluster.ce_waap.identity[0].principal_id
  role_definition_name = "Network Contributor"
  scope                = local.subnet_id
  depends_on = [azurerm_role_assignment.owner]
}
resource "local_file" "kubeconfig" {
  depends_on   = [azurerm_role_assignment.network-contributor]
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