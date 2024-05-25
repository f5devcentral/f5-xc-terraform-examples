
locals {
  project_prefix         = data.tfe_outputs.infra.values.project_prefix
  host                   = data.tfe_outputs.eks.values.kubernetes_cluster_host
  region                 = data.tfe_outputs.infra.values.aws_region
  cluster_ca_certificate = data.tfe_outputs.eks.values.kubeconfig-kubernetes_cluster_ca_certificate-authority-data
  cluster_name           = data.tfe_outputs.eks.values.kubernetes_cluster_name
}