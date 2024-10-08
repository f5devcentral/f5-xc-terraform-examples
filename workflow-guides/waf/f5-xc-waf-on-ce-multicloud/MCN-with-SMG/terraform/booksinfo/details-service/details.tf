resource "kubernetes_service" "bookinfo_details" {
  provider = kubernetes.aks
  metadata {
    name      = "details"
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

resource "kubernetes_service_account" "bookinfo_details" {
  provider = kubernetes.aks

  metadata {
    name      = "bookinfo-details"
    labels = {
      account = "details"
    }
  }
}

resource "kubernetes_deployment" "bookinfo_details" {
  provider = kubernetes.aks

  metadata {
    name = "details-v1"

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