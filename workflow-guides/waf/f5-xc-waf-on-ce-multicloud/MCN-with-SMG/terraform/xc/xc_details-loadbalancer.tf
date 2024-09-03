resource "volterra_origin_pool" "bookinfo_details" {
  name        = format("%s-bookinfo-details", local.project_prefix)
  depends_on  = [volterra_tf_params_action.action_apply]
  namespace   = var.xc_namespace
  description = "Origin Pool pointing to bookinfo details service"

  origin_servers {
    private_ip {
      ip = local.aks_node_private_ip
      site_locator {
        site {
          namespace = "system"
          name      = local.azure_site_name
        }
      }
    }
  }

  no_tls                 = true
  port                   = local.details_node_port
  endpoint_selection     = "LOCAL_PREFERRED"
  loadbalancer_algorithm = "LB_OVERRIDE"
}

resource "volterra_http_loadbalancer" "bookinfo_details" {
  name        = format("%s-bookinfo-details", local.project_prefix)
  depends_on  = [volterra_origin_pool.bookinfo_details, volterra_tf_params_action.apply_gcp_vpc]
  namespace   = var.xc_namespace
  description = "HTTP Load Balancer object for bookinfo details service"
  domains     = local.details_domain

  advertise_custom {
    advertise_where {
      site {
        network     = "SITE_NETWORK_INSIDE"
        site {
          namespace = "system"
          name      = local.gcp_site_name
        }
      }
    }
  }

  default_route_pools {
    pool {
      name      = volterra_origin_pool.bookinfo_details.name
      namespace = var.xc_namespace
    }
    weight      = 1
  }

  http {
    port        = 9080
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