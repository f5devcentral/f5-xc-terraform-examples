# Wait for appstack CE site creation
resource "null_resource" "wait_for_aws_ce_site"{
  count           =  var.user_site ? 1 : 0
  depends_on      =  [volterra_tf_params_action.apply_aws_vpc]
}

# Create XC LB config
resource "volterra_origin_pool" "op" {
  depends_on             = [null_resource.wait_for_aws_ce_site]
  name                   = format("%s-xcop", var.project_prefix)
  namespace              = var.xc_namespace
  description            = format("Origin pool pointing to origin server for %s", var.project_prefix)

  dynamic "origin_servers" {
    for_each = var.k8s_pool ? [1] : []
    content {
    k8s_service {
      service_name  = var.serviceName
      vk8s_networks = true
      outside_network = true
      site_locator {
        site {
          name      = volterra_aws_vpc_site.this.name
          namespace = "system"
          tenant    = var.xc_tenant
          }
        }
      }
    }
  }
  no_tls                  = true
  port                    = var.serviceport
  endpoint_selection      = "LOCAL_PREFERRED"
  loadbalancer_algorithm  = "LB_OVERRIDE"
}

resource "volterra_app_firewall" "waap-tf" {
  name                      = format("%s-firewall", var.project_prefix)
  description               = format("WAF in block mode for %s", var.project_prefix)
  namespace                 = var.xc_namespace
  allow_all_response_codes  = true
  default_anonymization     = true
  use_default_blocking_page = true
  default_bot_setting       = true
  default_detection_settings= true
  blocking                  = true
}

resource "volterra_http_loadbalancer" "lb_https" {
  depends_on             = [volterra_origin_pool.op]
  name                   = format("%s-xclb", var.project_prefix)
  namespace              = var.xc_namespace
  description            = format("HTTP load balancer object for %s origin server", var.project_prefix)
  domains                = [var.app_domain]
  advertise_on_public_default_vip = true

  dynamic "https_auto_cert" {
    for_each = var.http_only ? [] : [1]
    content {
      add_hsts              = false
      http_redirect         = true
      no_mtls               = true
      enable_path_normalize = true
      tls_config {
        default_security = true
      }
    }
  }

  default_route_pools {
    pool {
      name = volterra_origin_pool.op.name
      namespace = var.xc_namespace
    }
    weight = 1
}

  app_firewall {
    name      = volterra_app_firewall.waap-tf.name
    namespace = var.xc_namespace
  }
  round_robin                     = true
  service_policies_from_namespace = true
  user_id_client_ip = true
  source_ip_stickiness = true

  dynamic "more_option" {
    for_each = var.k8s_pool ? [1] : []
      content {
        idle_timeout = 600000
      }
    }
}
