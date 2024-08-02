# Create XC LB config
resource "volterra_namespace" "this" {
  name = local.namespace
  description = format("Namespace for %s", local.namespace)
}

resource "volterra_healthcheck" "aws-hc" {
  name = format("%s-aws-hc", local.name)
  namespace = local.namespace
  description = format("Healthcheck for origin server %s", local.aws_origin_server)
  http_health_check {
    path = "/"
    host_header = local.app_domain
    expected_status_codes = [ "200" ]
  }
  unhealthy_threshold = 1
  healthy_threshold = 3
  interval = 10
  timeout = 5
  depends_on = [ volterra_namespace.this ]
}

resource "volterra_origin_pool" "aws-op" {
  name                   = format("%s-xcop-aws", local.name)
  namespace              = local.namespace
  description            = format("Origin pool pointing to origin server %s", local.aws_origin_server)
  dynamic "origin_servers" {
    for_each = local.dns_origin_pool ? [1] : []
    content {
      /* k8s_service {
        service_name = local.service_name
        outside_network = true
        service_selector {
          expressions = ["k8s-svc=arcadia-ingress"]
        }
        site_locator {
          site {
            namespace = "system"
            name = local.aws_site_name
          }
        }
      } */

      private_ip {
        outside_network = true
        ip = local.aws_service_endpoint_ip
        site_locator {
          site {
            namespace = "system"
            name = local.aws_site_name
          }
        }  
      }
    }
  }
  /* dynamic "origin_servers" {
    for_each = local.dns_origin_pool ? [] : [1]
    content {
      public_ip {
        ip = local.origin_server
      } 
    }
  } */
  healthcheck {
        name = volterra_healthcheck.aws-hc.name
        namespace = local.namespace
  }
  no_tls = true
  port = local.aws_origin_port
  endpoint_selection     = "LOCAL_PREFERRED"
  loadbalancer_algorithm = "LB_OVERRIDE"

  depends_on = [ volterra_namespace.this ]

}

resource "volterra_origin_pool" "azure-op" {
  name                   = format("%s-xcop-azure", local.name)
  namespace              = local.namespace
  description            = format("Origin pool pointing to origin server %s", local.aws_origin_server)
  dynamic "origin_servers" {
    for_each = local.dns_origin_pool ? [1] : []
    content {
      /* k8s_service {
        service_name = local.service_name
        outside_network = true
        service_selector {
          expressions = ["k8s-svc=arcadia-ingress"]
        }
        site_locator {
          site {
            namespace = "system"
            name = local.aws_site_name
          }
        }
      } */

      private_ip {
        outside_network = true
        ip = local.azure_service_endpoint_ip
        site_locator {
          site {
            namespace = "system"
            name = local.azure_site_name
          }
        }  
      }
    }
  }
  lifecycle {
        # Force replacement of the origin_pool any time the IP in the cloud provider changes
        # Workaround note: In-place update doesn't currently work for the provider (2023-11-20)
        replace_triggered_by = [ kubernetes_service.app2.status[0].load_balancer[0].ingress[0].ip ]
  }
  depends_on = [ volterra_namespace.this ]

  /* dynamic "origin_servers" {
    for_each = local.dns_origin_pool ? [] : [1]
    content {
      public_ip {
        ip = local.origin_server
      } 
    }
  } */
  no_tls = true
  port = local.aks_origin_port
  endpoint_selection     = "LOCAL_PREFERRED"
  loadbalancer_algorithm = "LB_OVERRIDE"
}

resource "volterra_app_type" "app-type" {
  count = length(local.xc_app_type) != 0 ? 1 : 0
  name = format("%s-app-type", local.name)
  namespace = "shared"
  features {  
        type = "USER_BEHAVIOR_ANALYSIS" 
  }
  business_logic_markup_setting {
      enable = true
    }
}

resource "volterra_http_loadbalancer" "lb_https" {
  name      = format("%s-xclb", local.name)
  namespace = local.namespace
  labels = {
      "ves.io/app_type" = length(local.xc_app_type) != 0 ? volterra_app_type.app-type[0].name : null
  }
  description = format("HTTPS loadbalancer object for %s origin server", local.name)  
  domains = [ local.app_domain ]
  advertise_on_public_default_vip = true
  default_route_pools {
      pool {
        name = volterra_origin_pool.aws-op.name
        namespace = local.namespace
      }
      weight = 1
    }
  routes {
    simple_route {
      http_method = "ANY"
      path {
        prefix = "/api"
      }
      origin_pools {
        pool {
          name= volterra_origin_pool.azure-op.name
          namespace = local.namespace
        }
        weight = 1
      }
    }
  }
  https_auto_cert {
    add_hsts = false
    http_redirect = true
    no_mtls = true
    enable_path_normalize = true
    tls_config {
        default_security = true
      }
  }
  /* app_firewall {
    name = volterra_app_firewall.waap-tf.name
    namespace = local.namespace
  } */
  // disable_waf                     = false
  disable_waf                     = true
  round_robin                     = true
  service_policies_from_namespace = true
  multi_lb_app = local.xc_multi_lb
  user_id_client_ip = true
  source_ip_stickiness = true

#API Protection Configuration

  dynamic "enable_api_discovery" {
    for_each = local.xc_api_disc ? [1] : []
    content {
      enable_learn_from_redirect_traffic = true
    } 
  }

  dynamic "api_definition" {
    for_each = local.xc_api_pro ? [1] : []
    content {
      name = volterra_api_definition.api-def[0].name
      namespace = volterra_api_definition.api-def[0].namespace
    }
  }

  dynamic "api_protection_rules" {
    for_each = local.xc_api_pro ? [1] : []
    content {
      api_groups_rules {
        metadata {
          name = format("%s-apip-deny-rule", local.name)
        }
        action {
          deny = true
        }
        base_path = "/api"
        api_group = join("-",["ves-io-api-def", volterra_api_definition.api-def[0].name, "all-operations"])
      }
      api_groups_rules {
        metadata {
          name = format("%s-apip-allow-rule", local.name)
        }
        action {
          deny = false
        }
        base_path = "/"
      }
    }
  }

#BOT Configuration
  dynamic "bot_defense" {
    for_each = local.xc_bot_def ? [1] : []
    content {
      policy {
        javascript_mode = "ASYNC_JS_NO_CACHING"
        disable_js_insert = false
        js_insert_all_pages {
          javascript_location = "AFTER_HEAD"
        }
        disable_mobile_sdk = true
        js_download_path = "/common.js"
        protected_app_endpoints {
          metadata {
            name = format("%s-bot-rule", local.name)
          }
          http_methods = ["METHOD_POST", "METHOD_PUT"]
          mitigation {
            block {
              body = "string:///WW91ciByZXF1ZXN0IHdhcyBCTE9DS0VEID4uPAo="
            }
          }
          path {
            path = "/trading/login.php"
          }
          flow_label {
            authentication {
              login {
              }
            }
          }
        }
      }
      regional_endpoint = "US"
      timeout = 1000
    }
  }

#DDoS Configuration
  dynamic "ddos_mitigation_rules" {
    for_each = local.xc_ddos_def ? [1] : []
    content {
      metadata {
        name = format("%s-ddos-rule", local.name)
      }
      block = true
      ddos_client_source {
        country_list = [ "COUNTRY_KP"]
      }
    }
  }
  
#Common Security Controls

  disable_rate_limit              = true
  enable_malicious_user_detection = local.xc_mud ? true : null
  no_challenge = contains(local.xc_app_type, "mud") || local.xc_mud ? false : true

  dynamic "policy_based_challenge" {
    for_each = local.xc_mud ? [1] : []
    content {
      default_js_challenge_parameters = true
      default_captcha_challenge_parameters = true
      default_mitigation_settings = true
      no_challenge = true
      rule_list {}
    }
  }
  dynamic "policy_based_challenge" {
    for_each = contains(local.xc_app_type, "mud") && local.xc_multi_lb ? [1] : []
    content {
      malicious_user_mitigation {
        namespace = volterra_malicious_user_mitigation.mud-mitigation[0].namespace
        name = volterra_malicious_user_mitigation.mud-mitigation[0].name
      } 
    }
  }
}


