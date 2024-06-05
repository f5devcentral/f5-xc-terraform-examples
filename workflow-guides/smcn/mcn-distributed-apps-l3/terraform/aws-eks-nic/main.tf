provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_token
}

provider "kubernetes" {
    host                   = ("" != local.k8s_host) ? local.k8s_host : data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = ("" != local.k8s_ca_certificate) ? local.k8s_ca_certificate : base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
}
provider "helm" {
    kubernetes {
        host                   = ("" != local.k8s_host) ? local.k8s_host : data.aws_eks_cluster.eks.endpoint
        cluster_ca_certificate = ("" != local.k8s_ca_certificate) ? local.k8s_ca_certificate : base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
        token                  = data.aws_eks_cluster_auth.eks.token
    }
}