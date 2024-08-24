resource "volterra_origin_pool" "bookinfo_details" {
  name        = format("%s-bookinfo-details", local.name)
  namespace   = local.xc_namespace
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
  name        = format("%s-bookinfo-details", local.name)
  namespace   = local.xc_namespace
  description = "HTTP Load Balancer object for bookinfo details service"

  domains = [ local.details_domain ]

  advertise_custom {
    advertise_where {
      site {
        network = "SITE_NETWORK_INSIDE"
        site {
          namespace = "system"
          name      = local.aws_site_name
        }
      }
    }
  }

  default_route_pools {
    pool {
      name      = volterra_origin_pool.bookinfo_details.name
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