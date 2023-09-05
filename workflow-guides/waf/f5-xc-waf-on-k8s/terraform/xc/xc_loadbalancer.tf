# Create XC LB config
resource "volterra_origin_pool" "k8s-site-op" {
  name                   = format("%s-xcop-%s", local.project_prefix, local.build_suffix)
  namespace              = var.xc_namespace
  endpoint_selection     = "LOCAL_PREFERRED"
  loadbalancer_algorithm = "LB_OVERRIDE"
  port                   = 9080
  no_tls                 = true

  dynamic "origin_servers" {
    for_each = local.k8s_origin_pool ? [1] : [0]
    content {
    k8s_service {
      service_name  = var.serviceName
      vk8s_networks = true
      outside_network = true
      site_locator {
        site {
          name      = var.deployment
          namespace = "system"
          }
        }
      }
    }
  }
}

resource "volterra_http_loadbalancer" "k8s-site-demo" {
  name                            = format("%s-xclb-%s", local.project_prefix, local.build_suffix)
  namespace                       = var.xc_namespace
  no_challenge                    = true
  domains                         = [var.app_domain]

  advertise_custom = true
  disable_rate_limit              = true
  service_policies_from_namespace = true
  disable_waf                     = false

  app_firewall {
    name = volterra_app_firewall.waap-tf.name
    namespace = var.xc_namespace
  }

  advertise_custom {
    advertise_where {
      site {
        site {
          name      = "ce-k8s"
          namespace = "system"
        }
      }
    }
  }

  https_auto_cert {
    http_redirect = true
  }

  default_route_pools {
    pool {
      namespace = var.xc_namespace
      name = volterra_origin_pool.k8s-site-op.name
    }
  }
  round_robin = true

  enable_ip_reputation {
    ip_threat_categories = [ "SPAM_SOURCES", "NETWORK", "MOBILE_THREATS" ]
  }

  depends_on = [ volterra_origin_pool.k8s-site-op]
}
