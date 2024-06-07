#------------------------------------------------
# AWS section
#------------------------------------------------

data "aws_eks_cluster" "eks" {
  name = ("" != local.eks_cluster_name) ? local.eks_cluster_name : format("%s-eks-cluster", local.name)
}

data "aws_eks_cluster_auth" "eks" {
  name = ("" != local.eks_cluster_name) ? local.eks_cluster_name : format("%s-eks-cluster", local.name)
}

data "kubernetes_endpoints_v1" "origin-pool-k8s-service" {
  provider = kubernetes.eks

  metadata {
    name = local.aws_service_name
    namespace = "nginx-ingress"
  }
}

#------------------------------------------------
# Azure section
#------------------------------------------------

data "azurerm_kubernetes_cluster" "aks" {
  name                =  ("" != local.aks_cluster_name) ? local.aks_cluster_name : format("%s-aks-cluster", local.name)
  resource_group_name = local.azure_resource_group_name
}

data "kubernetes_service_v1" "api" {
  provider = kubernetes.aks

  metadata {
    name = "app2"
    namespace = kubernetes_namespace.aks-app.metadata[0].name
  }
  depends_on = [kubernetes_deployment.app2]
}

#------------------------------------------------
# GCP
#------------------------------------------------

data "google_client_config" "default" {}

data "google_service_account" "me" {
  account_id = local.gcp_account_id
}

data "google_container_cluster" "gke" {
  name     = ("" != local.gke_cluster_name) ? local.gke_cluster_name : format("%s-gke-cluster", local.name)
  location = local.gcp_region
  project  = local.gcp_project_id
}
