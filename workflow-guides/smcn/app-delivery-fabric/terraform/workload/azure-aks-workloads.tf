resource "kubernetes_namespace" "aks_namespace" {
  count = local.create_aks_namespace ? 1 : 0

  provider = kubernetes.aks

  metadata {
    annotations = {
      name = local.namespace
    }
    name = local.namespace
  }
}

resource "kubernetes_service_account" "bookinfo_details" {
  provider = kubernetes.aks

  metadata {
    name      = "bookinfo-details"
    namespace = local.aks_namespace
    labels = {
      account = "details"
    }
  }
}

resource "kubernetes_deployment" "bookinfo_details" {
  provider = kubernetes.aks

  metadata {
    name = "details-v1"
    namespace = local.aks_namespace

    labels = {
      app     = "details"
      version = "v1"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app     = "details"
        version = "v1"
      }
    }
    template {
      metadata {
        labels = {
          app     = "details"
          version = "v1"
        }
      }
      spec {
        service_account_name = "bookinfo-details"
        container {
          name    = "details"
          image   = "docker.io/istio/examples-bookinfo-details-v1:1.19.1"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 9080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "bookinfo_details" {
  provider = kubernetes.aks

  metadata {
    name      = "details"
    namespace = local.aks_namespace
    labels = {
      app     = "details"
      service = "details"
    
    }
  }
  spec {
    type = "NodePort"
    port {
      name      = "http"
      port      = 9080
      node_port = 31002
    }

    selector = {
      app = "details"
    }
  }
}
