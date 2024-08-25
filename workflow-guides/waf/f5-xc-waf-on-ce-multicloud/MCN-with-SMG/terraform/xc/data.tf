data "tfe_outputs" "azure-infra" {
  organization  = var.tf_cloud_organization
  workspace     = "azure-infra"
}

data "tfe_outputs" "aks-cluster" {
  organization  = var.tf_cloud_organization
  workspace     = "aks-cluster"
}

data "tfe_outputs" "gcp-infra" {
  organization  = var.tf_cloud_organization
  workspace     = "gcp-infra"
}

data "tfe_outputs" "gke" {
  organization  = var.tf_cloud_organization
  workspace     = "gke"
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = format("%s-aks-%s", local.project_prefix, local.build_suffix_azure)
  resource_group_name = local.azure_resource_group
}

data "kubernetes_nodes" "aks" {
  provider = kubernetes.aks
}