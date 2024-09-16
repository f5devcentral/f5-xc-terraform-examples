resource "volterra_origin_pool" "bookinfo_product" {
  name        = format("%s-bookinfo-productpage", local.project_prefix)
  depends_on  = [volterra_tf_params_action.apply_gcp_vpc]
  namespace   = var.xc_namespace
  description = "Origin Pool pointing to bookinfo product page service"

  origin_servers {
    private_ip {
      ip                 = local.gcp_node_ip
      outside_network    = true
      site_locator {
        site {
          namespace      = "system"
          name           = local.gcp_site_name
          tenant         = var.xc_tenant
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
  name        = format("%s-bookinfo-productpage", local.project_prefix)
  depends_on  = [volterra_origin_pool.bookinfo_product]
  namespace   = var.xc_namespace
  description = "HTTP Load Balancer object for bookinfo product page service"
  domains     = [ var.app_domain ]

  advertise_custom {
    advertise_where {
      site {
        network     = "SITE_NETWORK_OUTSIDE"
        site {
          namespace = "system"
          name      = local.gcp_site_name
          tenant    = var.xc_tenant
        }
      }
    }
  }

  default_route_pools {
    pool {
      name      = volterra_origin_pool.bookinfo_product.name
      namespace = var.xc_namespace
    }
    weight      = 1
  }

  http {
    port        = 80
  }

  app_firewall {
    name        = volterra_app_firewall.waap-tf.name
    namespace   = var.xc_namespace
  }
  round_robin                     = true
  service_policies_from_namespace = true
  user_id_client_ip               = true
  source_ip_stickiness            = true
}