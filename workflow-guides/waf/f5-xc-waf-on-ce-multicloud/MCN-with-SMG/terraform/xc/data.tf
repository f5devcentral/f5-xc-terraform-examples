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

data "google_compute_instance_group"  "ce-site" {
  depends_on  = [volterra_tf_params_action.apply_gcp_vpc]
  name        = local.gcp_site_name
  zone        = format("%s-a", local.gcp_region)
}

locals {
  instance_ids = [for instance in data.google_compute_instance_group.ce-site.instances : basename(instance)]
}

data "google_compute_instance" "instances" {
  for_each    = toset(local.instance_ids)
  self_link   = "projects/${data.google_compute_instance_group.ce-site.project}/zones/${data.google_compute_instance_group.ce-site.zone}/instances/${each.key}"
}

