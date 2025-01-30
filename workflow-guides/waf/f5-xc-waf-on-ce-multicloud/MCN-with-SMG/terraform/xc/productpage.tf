resource "kubernetes_deployment" "productpage_v1" {
  provider = kubernetes.gke
  depends_on  = [volterra_tf_params_action.apply_gcp_vpc]
  metadata {
    name = "productpage-v1"
    labels = {
      app = "productpage"
      version = "v1"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "productpage"
        version = "v1"
      }
    }

    template {
      metadata {
        labels = {
          app = "productpage"
          version = "v1"
        }
      }

      spec {
        service_account_name = "bookinfo-productpage"

        container {
          name  = "productpage"
          image = "docker.io/istio/examples-bookinfo-productpage-v1:1.17.0"
          image_pull_policy = "IfNotPresent"

          port {
            container_port = 9080
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          security_context {
            run_as_user = 1000
          }
        }

        host_aliases {
          ip        = local.gcp_ce_details.2
          hostnames = ["details"]
        }

        volume {
          name = "tmp"
          empty_dir {}
        }
      }
    }
  }
}