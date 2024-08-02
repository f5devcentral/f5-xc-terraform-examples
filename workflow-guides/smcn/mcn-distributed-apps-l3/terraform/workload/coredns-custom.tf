resource "kubernetes_config_map_v1_data" "coredns-eks" {
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
          ${local.aws_service_endpoint_ip} backend.demo.internal
          ${local.gke_load_balancer_ip} refer-a-friend.demo.internal
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

  depends_on = [ kubernetes_service.backend, kubernetes_service.app3 ]
}

resource "kubernetes_config_map_v1_data" "coredns-custom-aks" {
  provider = kubernetes.aks

  metadata {
    name = "coredns-custom"
    namespace = "kube-system"
  }

  /* data = tomap({"${var.projectPrefix}.server" = <<-EOT
        ${var.projectPrefix}-${local.build_suffix}.${var.domain_name}:53 {
          errors
          cache 30
          forward . ${local.xc_site_slo_ip}
        }
        EOT
      }) */
  data = tomap({"${local.name}.override" = <<-EOT
    hosts {
      ${local.aws_service_endpoint_ip} backend.demo.internal
        fallthrough
      }
      EOT
  })

  depends_on = [ kubernetes_service.backend ]
}