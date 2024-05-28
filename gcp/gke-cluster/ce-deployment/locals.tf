locals {
  project_prefix          = data.tfe_outputs.infra.values.project_prefix
  host                    = data.tfe_outputs.gke.values.kubernetes_cluster_host
  gcp_region              = data.tfe_outputs.infra.values.gcp_region
  cluster_ca_certificate  = data.tfe_outputs.gke.values.kubernetes_cluster_ca_certificate
  cluster_name            = data.tfe_outputs.gke.values.kubernetes_cluster_name
}