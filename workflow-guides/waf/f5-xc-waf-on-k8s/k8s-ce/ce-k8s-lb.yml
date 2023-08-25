resource "kubernetes_manifest" "service_ves_system_lb_ver" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "lb-ver"
      "namespace" = "ves-system"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "http"
          "port" = 80
        },
      ]
      "selector" = {
        "app" = "ver"
      }
      "type" = "LoadBalancer"
    }
  }
}
