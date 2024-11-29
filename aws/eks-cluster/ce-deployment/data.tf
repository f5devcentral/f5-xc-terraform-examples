data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organization
  workspace = "${coalesce(var.aws_waf_ce, "infra")}"
}
data "tfe_outputs" "eks" {
  organization = var.tf_cloud_organization
  workspace = "eks"
}

data "aws_eks_cluster_auth" "auth" {
  name = data.tfe_outputs.eks.values.cluster_name
}
