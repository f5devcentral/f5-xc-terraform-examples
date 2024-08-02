resource "kubernetes_namespace" "eks_namespace" {
  count = local.create_eks_namespace ? 1 : 0

  provider = kubernetes.eks

  metadata {
    annotations = {
      name = local.namespace
    }
    name = local.namespace
  }
}

resource "kubernetes_config_map_v1_data" "coredns_eks" {
  provider = kubernetes.eks

  metadata {
    name = "coredns"
    namespace = "kube-system"
  }
  force = true

  data = tomap({"Corefile" = <<-EOT
    .:53 {
        errors
        health {
          lameduck 5s
        }
        ready
        hosts {
          ${local.aws_xc_node_inside_ip} ${local.details_domain}
          fallthrough
        }
        kubernetes cluster.local in-addr.arpa ip6.arpa {
          pods insecure
          fallthrough in-addr.arpa ip6.arpa
        }
        prometheus :9153
        forward . /etc/resolv.conf
        cache 30
        loop
        reload
        loadbalance
    }
    EOT
  })
}

resource "kubernetes_service_account" "bookinfo_product" {
  provider = kubernetes.eks

  metadata {
    name      = "bookinfo-productpage"
    namespace = local.eks_namespace
    labels = {
      account = "productpage"
    }
  }
}

resource "kubernetes_deployment" "bookinfo_product" {
  provider = kubernetes.eks

  metadata {
    name = "productpage-v1"
    namespace = local.eks_namespace

    labels = {
      app     = "productpage"
      version = "v1"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app     = "productpage"
        version = "v1"
      }
    }
    template {
      metadata {
        labels = {
          app     = "productpage"
          version = "v1"
        }
      }
      spec {
        service_account_name = "bookinfo-productpage"
        container {
          name    = "productpage"
          image   = "docker.io/istio/examples-bookinfo-productpage-v1:1.19.1"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 9080
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          env {
            name  = "DETAILS_HOSTNAME"
            value = local.details_domain
          }

          env {
            name  = "DETAILS_SERVICE_PORT"
            value = "80"
          }
        }

        volume {
          name = "tmp"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_service" "bookinfo_product" {
  provider = kubernetes.eks

  metadata {
    name      = "productpage"
    namespace = local.eks_namespace
    labels = {
      app     = "productpage"
      service = "productpage"
    
    }
  }
  spec {
    type = "NodePort"
    port {
      name      = "http"
      port      = 9080
      node_port = 31001
    }

    selector = {
      app = "productpage"
    }
  }
}
