# terraform {
#   cloud {
#     organization = "example-org-fa8f78"
#     workspaces {
#       name = "xcmcn-ce-nic"
#     }
#   }
# }

# data "tfe_outputs" "root" {
#   organization = var.tf_cloud_organization
#   workspace = "xcmcn-ce-root"
# }
# data "tfe_outputs" "infra" {
#   organization = var.tf_cloud_organization
#   workspace = "xcmcn-ce-aws"
# }
# data "tfe_outputs" "eks" {
#   organization = var.tf_cloud_organization
#   workspace = "xcmcn-ce-aws-eks"
# }

data "aws_eks_cluster" "eks" {
  name = ("" != local.eks_cluster_name) ? local.eks_cluster_name : format("%s-eks-cluster", local.name)
}

data "aws_eks_cluster_auth" "eks" {
  name = ("" != local.eks_cluster_name) ? local.eks_cluster_name : format("%s-eks-cluster", local.name)
}

data "kubernetes_service_v1" "nginx-service" {
  metadata {
    name = format("%s-%s-controller", helm_release.nginx-plus-ingress.name, helm_release.nginx-plus-ingress.chart)
    namespace = helm_release.nginx-plus-ingress.namespace
  }
  depends_on = [helm_release.nginx-plus-ingress]
}