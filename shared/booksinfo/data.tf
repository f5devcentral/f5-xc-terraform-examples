data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organization
<<<<<<< HEAD
  workspace = "aws-infra"
=======
  workspace = "${coalesce(var.aws_waf_ce, "infra")}"
>>>>>>> 7759e1229d807d2da94cb1cc2c18127d452be360
}
data "tfe_outputs" "eks" {
  organization = var.tf_cloud_organization
  workspace = "eks"
}

data "aws_eks_cluster_auth" "auth" {
  name = data.tfe_outputs.eks.values.cluster_name
}
