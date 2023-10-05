# Create XC LB config

resource "volterra_origin_pool" "op" {
  name        = format("%s-xcop-%s", local.project_prefix, local.build_suffix)
  namespace   = var.xc_namespace
  description = format("Origin pool pointing to origin server %s", var.origin_server)
  dynamic "origin_servers" {
    for_each = var.dns_origin_pool ? [1] : []
    content {
      public_name {
        dns_name = var.origin_server
      }
    }
  }
  dynamic "origin_servers" {
    for_each = var.dns_origin_pool ? [] : [1]
    content {
      public_ip {
        ip = var.origin_server
      }
    }
  }
  no_tls                 = true
  port                   = var.origin_port
  endpoint_selection     = "LOCAL_PREFERRED"
  loadbalancer_algorithm = "LB_OVERRIDE"
}

resource "volterra_http_loadbalancer" "lb_https" {
  name                            = format("%s-xclb-%s", local.project_prefix, local.build_suffix)
  namespace                       = var.xc_namespace
  description                     = format("HTTPS loadbalancer object for %s origin server", local.project_prefix)
  domains                         = [var.app_domain]
  advertise_on_public_default_vip = true
  default_route_pools {
    pool {
      name      = volterra_origin_pool.op.name
      namespace = var.xc_namespace
    }
    weight = 1
  }
  https_auto_cert {
    add_hsts              = false
    http_redirect         = true
    no_mtls               = true
    enable_path_normalize = true
    tls_config {
      default_security = true
    }
  }
  disable_waf                     = true
  round_robin                     = true
  service_policies_from_namespace = true
  user_id_client_ip               = true
  source_ip_stickiness            = true

  #API Protection Configuration

  dynamic "enable_api_discovery" {
    for_each = var.xc_api_disc ? [1] : []
    content {
      enable_learn_from_redirect_traffic = true
    }
  }
  dynamic "api_specification" {
    for_each = var.xc_api_pro ? [1] : []
    content {
      api_definition {
        name      = volterra_api_definition.api-def[0].name
        namespace = volterra_api_definition.api-def[0].namespace
        tenant    = var.xc_tenant
      }
      validation_disabled = var.xc_api_val ? false : true
      dynamic "validation_all_spec_endpoints" {
        for_each = var.xc_api_val_all ? [1] : []
        content {
          validation_mode {
            dynamic "validation_mode_active" {
              for_each = var.xc_api_val_active ? [1] : []
              content {
                request_validation_properties = var.xc_api_val_properties
                enforcement_block             = var.enforcement_block
                enforcement_report            = var.enforcement_report
              }
            }
          }
          fall_through_mode {
            fall_through_mode_allow = var.fall_through_mode_allow ? true : false
            dynamic "fall_through_mode_custom" {
              for_each = var.fall_through_mode_allow ? [0] : [1]
              content {
                open_api_validation_rules {
                  metadata {
                    name = format("%s-apip-fall-through-block-%s", local.project_prefix, local.build_suffix)
                  }
                  action_block = true
                  base_path    = "/"
                }
                open_api_validation_rules {
                  metadata {
                    name = format("%s-apip-fall-through-report-%s", local.project_prefix, local.build_suffix)
                  }
                  action_report = true
                  base_path     = "/"
                }
              }
            }
          }
        }
      }
      dynamic "validation_custom_list" {
        for_each = var.xc_api_val_custom ? [1] : []
        content {
          open_api_validation_rules {
            metadata {
              name = format("%s-apip-val-rule-block-%s", local.project_prefix, local.build_suffix)
            }
            validation_mode {
              dynamic "validation_mode_active" {
                for_each = var.xc_api_val_active ? [1] : []
                content {
                  request_validation_properties = var.xc_api_val_properties
                  enforcement_block             = var.enforcement_block
                  enforcement_report            = var.enforcement_report
                }
              }
            }
            any_domain = true
            base_path  = "/"
          }
          fall_through_mode {
            fall_through_mode_allow = var.fall_through_mode_allow ? true : false
            dynamic "fall_through_mode_custom" {
              for_each = var.fall_through_mode_allow ? [0] : [1]
              content {
                open_api_validation_rules {
                  metadata {
                    name = format("%s-apip-fall-through-block-%s", local.project_prefix, local.build_suffix)
                  }
                  action_block = true
                  base_path    = "/"
                }
                open_api_validation_rules {
                  metadata {
                    name = format("%s-apip-fall-through-report-%s", local.project_prefix, local.build_suffix)
                  }
                  action_report = true
                  base_path     = "/"
                }
              }
            }
          }
        }
      }
    }
  }

  dynamic "api_protection_rules" {
    for_each = var.xc_api_pro ? [1] : []
    content {
      api_groups_rules {
        metadata {
          name = format("%s-apip-deny-rule-%s", local.project_prefix, local.build_suffix)
        }
        action {
          deny = true
        }
        base_path = "/api"
        api_group = join("-", ["ves-io-api-def", volterra_api_definition.api-def[0].name, "all-operations"])
      }
      api_groups_rules {
        metadata {
          name = format("%s-apip-allow-rule-%s", local.project_prefix, local.build_suffix)
        }
        action {
          deny = false
        }
        base_path = "/"
      }
    }
  }
}


