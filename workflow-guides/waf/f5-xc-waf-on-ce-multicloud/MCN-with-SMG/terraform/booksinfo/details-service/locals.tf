locals {
  project_prefix          = data.tfe_outputs.azure-infra.values.project_prefix
  build_suffix            = data.tfe_outputs.azure-infra.values.build_suffix
  host                    = data.tfe_outputs.eks.values.cluster_endpoint
  azure_region            = data.tfe_outputs.azure-infra.values.azure_region
  cluster_ca_certificate  = data.tfe_outputs.eks.values.kubeconfig-certificate-authority-data
  cluster_name            = data.tfe_outputs.eks.values.cluster_name
} 
