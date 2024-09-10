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

data "google_client_config" "provider" {}

data "google_container_cluster" "my_cluster" {
  name     = local.gke_cluster_name
  location = local.gcp_region
}

data "kubernetes_nodes" "gke" {
  provider = kubernetes.gke
}

 data "google_compute_region_instance_group_manager" "ce-site" {
  depends_on  = [volterra_tf_params_action.apply_gcp_vpc]
  name        = local.gcp_site_name
  region      = local.gcp_region
}

data "google_compute_instance" "my_instance" {
  for_each = { for instance in data.google_compute_region_instance_group_manager.ce-site.instances : instance.instance  => instance }
  name = each.key
  zone = each.value.zone
}

