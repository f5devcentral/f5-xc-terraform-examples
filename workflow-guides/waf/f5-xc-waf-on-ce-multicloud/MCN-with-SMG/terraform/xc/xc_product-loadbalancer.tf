resource "aws_vpc_security_group_ingress_rule" "allow_ingress_http" {
  count             = ("" != local.xc_security_group_id) ? 1 : 0

  description       = "Allow ingress HTTP traffic"
  security_group_id = local.xc_security_group_id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}


resource "volterra_origin_pool" "bookinfo_product" {
  name        = format("%s-bookinfo-productpage", local.name)
  namespace   = local.xc_namespace
  description = "Origin Pool pointing to bookinfo product page service"

  origin_servers {
    private_ip {
      ip = local.eks_node_private_ip
      site_locator {
        site {
          namespace = "system"
          name      = local.aws_site_name
        }
      }
    }
  }

  no_tls                 = true
  port                   = local.product_node_port
  endpoint_selection     = "LOCAL_PREFERRED"
  loadbalancer_algorithm = "LB_OVERRIDE"
}

resource "volterra_http_loadbalancer" "bookinfo_product" {
  name        = format("%s-bookinfo-productpage", local.name)
  namespace   = local.xc_namespace
  description = "HTTP Load Balancer object for bookinfo product page service"

  domains = [ local.app_domain ]

  advertise_custom {
    advertise_where {
      site {
        network = "SITE_NETWORK_OUTSIDE"
        site {
          namespace = "system"
          name      = local.aws_site_name
        }
      }
    }
  }

  default_route_pools {
    pool {
      name      = volterra_origin_pool.bookinfo_product.name
      namespace = local.xc_namespace
    }
    weight = 1
  }

  http {
    port = 80
  }

  disable_waf                     = true
  round_robin                     = true
  service_policies_from_namespace = true
  user_id_client_ip               = true
  source_ip_stickiness            = true
}