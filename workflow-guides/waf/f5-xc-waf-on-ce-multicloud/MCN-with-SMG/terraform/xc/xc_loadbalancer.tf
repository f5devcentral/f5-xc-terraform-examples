# Wait for CE site creation
resource "null_resource" "wait_for_site"{
  count           =  var.az_ce_site ? 1 : 0
  depends_on      =  [volterra_tf_params_action.action_apply]
}

# Create XC OP and LB configs
resource "volterra_origin_pool" "product" {
  depends_on             = [null_resource.wait_for_site]
  name                   = format("%s-xcop-%s", local.project_prefix, local.build_suffix)
  namespace              = var.xc_namespace
  description            = format("Origin pool pointing to origin server %s", local.origin_server)

  dynamic "origin_servers" {
    for_each = var.k8s_pool ? [1] : []
    content {
    k8s_service {
      service_name  = ""
      vk8s_networks = true
      outside_network = true
      site_locator {
        site {
          name      = "${coalesce(var.site_name, local.project_prefix)}"
          namespace = "system"
          tenant    = var.xc_tenant
          }
        }
      }
    }
  }
  no_tls = true
  port                    = 8000
  endpoint_selection      = "LOCAL_PREFERRED"
  loadbalancer_algorithm  = "LB_OVERRIDE"
}

resource "volterra_origin_pool" "details" {
  depends_on             = [null_resource.wait_for_site]
  name                   = format("%s-xcop-%s", local.project_prefix, local.build_suffix)
  namespace              = var.xc_namespace
  description            = format("Origin pool pointing to origin server %s", local.origin_server)

  dynamic "origin_servers" {
    for_each = var.k8s_pool ? [1] : []
    content {
    k8s_service {
      service_name  = ""
      vk8s_networks = true
      outside_network = true
      site_locator {
        site {
          name      = "${coalesce(var.site_name, local.project_prefix)}"
          namespace = "system"
          tenant    = var.xc_tenant
          }
        }
      }
    }
  }
  no_tls = true
  port                    = 8000
  endpoint_selection      = "LOCAL_PREFERRED"
  loadbalancer_algorithm  = "LB_OVERRIDE"
}


resource "volterra_http_loadbalancer" "lb_product" {
  depends_on             =  [volterra_origin_pool.op, volterra_tf_params_action.apply_gcp_vpc]
  name                   = format("%s-xclb-%s", local.project_prefix, local.build_suffix)
  namespace              = var.xc_namespace
  labels                 = {
      "ves.io/app_type"  = length(var.xc_app_type) != 0 ? volterra_app_type.app-type[0].name : null
  }
  description            = format("HTTP loadbalancer object for %s origin server", local.project_prefix)
  domains                = [var.app_domain]
  advertise_on_public_default_vip = true

  dynamic "advertise_custom" {
    for_each = var.advertise_sites ? [1] : []
    content {
      advertise_where {
        site {
          site {
            name      = "${coalesce(var.gke_site_name, var.site_name, local.project_prefix)}"
            namespace = "system"
          }
          network = "SITE_NETWORK_INSIDE_AND_OUTSIDE"
        }
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

  dynamic "http" {
    for_each = var.http_only ? [1] : []
    content  {
      dns_volterra_managed = var.xc_delegation
      port = "80"
      }
  }

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

  app_firewall {
    name = volterra_app_firewall.waap-tf.name
    namespace = var.xc_namespace
  }
  disable_waf                     = false
  round_robin                     = true
  service_policies_from_namespace = true
  user_id_client_ip               = true
  source_ip_stickiness            = true
}



resource "volterra_http_loadbalancer" "lb_details" {
  depends_on             = [volterra_origin_pool.op, volterra_tf_params_action.apply_gcp_vpc]
  name                   = format("%s-xclb-%s", local.project_prefix, local.build_suffix)
  namespace              = var.xc_namespace
  labels                 = {
      "ves.io/app_type"  = length(var.xc_app_type) != 0 ? volterra_app_type.app-type[0].name : null
  }
  description            = format("HTTP loadbalancer object for %s origin server", local.project_prefix)
  domains                = "details"
  advertise_on_public_default_vip = false

  dynamic "advertise_custom" {
    for_each = var.advertise_sites ? [1] : []
    content {
      advertise_where {
        site {
          site {
            name      = "${coalesce(var.gke_site_name, var.site_name, local.project_prefix)}"
            namespace = "system"
          }
          network = "SITE_NETWORK_INSIDE_AND_OUTSIDE"
        }
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

  dynamic "http" {
    for_each  = var.http_only ? [1] : []
    content  {
      dns_volterra_managed = var.xc_delegation
      port    = "80"
      }
  }

  app_firewall {
    name      = volterra_app_firewall.waap-tf.name
    namespace = var.xc_namespace
  }
  round_robin                     = true
  service_policies_from_namespace = true
  user_id_client_ip               = true
  source_ip_stickiness            = true
}
