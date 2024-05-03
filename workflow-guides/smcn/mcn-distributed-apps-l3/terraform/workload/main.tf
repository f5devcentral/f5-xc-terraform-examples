provider "kubernetes" {
  alias = "eks"
  host                   = ("" != local.eks_cluster_host) ? local.eks_cluster_host : data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = ("" != local.eks_cluster_ca_certificate) ? local.eks_cluster_ca_certificate : base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "kubernetes" {
  alias = "aks"
  host                   = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
  username               = data.azurerm_kubernetes_cluster.aks.kube_config[0].username
  password               = data.azurerm_kubernetes_cluster.aks.kube_config[0].password
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
}

provider "kubernetes" {
  alias                  = "gke"
  host                   = "https://${data.google_container_cluster.gke.endpoint}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.gke.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}

provider "helm" {
    kubernetes {
      host                   = ("" != local.eks_cluster_host) ? local.eks_cluster_host : data.aws_eks_cluster.eks.endpoint
      cluster_ca_certificate = ("" != local.eks_cluster_ca_certificate) ? local.eks_cluster_ca_certificate : base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
      token                  = data.aws_eks_cluster_auth.eks.token
    }
}

provider "volterra" {
  api_p12_file = var.xc_api_p12_file
  url          = var.xc_api_url
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_token
}

provider "google" {
  project = local.gcp_project_id
  region  = local.gcp_region
}

provider "azurerm" {
  features {}
  skip_provider_registration = "true"

  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
}