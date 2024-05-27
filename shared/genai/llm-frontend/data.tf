
data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organization
  workspace = "gcp_infra"
}

data "tfe_outputs" "eks" {
  organization = var.tf_cloud_organization
  workspace = "gke"
}

data "aws_eks_cluster_auth" "auth" {
  name = data.tfe_outputs.eks.values.kubernetes_cluster_name
}