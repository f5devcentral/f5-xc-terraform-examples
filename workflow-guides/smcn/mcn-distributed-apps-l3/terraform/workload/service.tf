# AWS
resource "kubernetes_service" "main" {
  provider = kubernetes.eks

  metadata {
    name      = "main"
    namespace = kubernetes_namespace.eks-app.metadata.0.name

    labels = {
      app     = "main"
      service = "main"
    }
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 80
      target_port = "8080"
    }
    selector = {
      app = "main"
    }
    type = "ClusterIP"
  }
}
resource "kubernetes_service" "backend" {
  provider = kubernetes.eks
  
  metadata {
    name      = "backend"
    namespace = kubernetes_namespace.eks-app.metadata.0.name

    labels = {
      app     = "backend"
      service = "backend"
    }
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 80
      target_port = "8080"
    }
    selector = {
      app = "backend"
    }
    type = "ClusterIP"
  }
}

# Azure
resource "kubernetes_service" "app2" {
  provider = kubernetes.aks

  metadata {
    name      = "app2"
    namespace = kubernetes_namespace.aks-app.metadata.0.name
    annotations = {
      "service.beta.kubernetes.io/azure-load-balancer-internal" = "true"
      "service.beta.kubernetes.io/azure-load-balancer-internal-subnet" = "${local.azure_internal_subnet_name}"
    }

    labels = {
      app     = "app2"
      service = "app2"
    }
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 80
      target_port = "8080"
    }
    selector = {
      app = "app2"
    }
    // type = "ClusterIP"
    type = "LoadBalancer"
  }
}

# GCP
resource "kubernetes_service" "app3" {
  provider = kubernetes.gke

  metadata {
    name      = "app3"
    namespace = kubernetes_namespace.gke-app.metadata[0].name
    annotations = {
      "cloud.google.com/neg" = "{\"ingress\": true}"
      }

    labels = {
      app     = "app3"
      service = "app3"
    }
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 80
      target_port = "8080"
    }
    selector = {
      app = "app3"
    }
    type = "ClusterIP"
    // external_traffic_policy = "Cluster"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].annotations["cloud.google.com/neg-status"]
    ]
  }
}
