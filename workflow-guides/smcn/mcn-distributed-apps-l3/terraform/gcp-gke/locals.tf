locals {
  name            = ("" != var.prefix) ? format("%s-%s", var.prefix, var.name) : var.name
  project_id      = var.gcp_project_id
  gke_num_nodes   = "1"
  region                     = var.gcp_region
  gke_machine_type = "n1-standard-1"

  network_name    = var.network_name
  subnet_name     = var.subnet_name
  cluster_cird    = var.cluster_cidr
  services_cird   = var.services_cidr
}
