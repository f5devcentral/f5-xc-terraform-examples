#-----------------------------------------------------
# SSH Key
#-----------------------------------------------------

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#-----------------------------------------------------
# Cloud Credentials
#-----------------------------------------------------

resource "volterra_cloud_credentials" "gcp" {
  count = ("" == var.xc_gcp_cloud_credentials) ? 1 : 0
  name      = format("%s-creds", local.name)
  namespace = local.system_namespace

  gcp_cred_file {
    credential_file {
      clear_secret_info {
        url = "string:///${base64encode(local.xc_gcp_credentials)}"
      }
    }
  }
}

#-----------------------------------------------------
# Create a GCP VPC site
#-----------------------------------------------------

resource "volterra_gcp_vpc_site" "perimeter" {
  name        = format("%s-gcp", local.name)
  namespace   = "system"
  description = format("GCP VPC Site (%s)", local.name)

  coordinates {
    latitude  = module.region_locations.lookup[local.gcpRegion].latitude
    longitude = module.region_locations.lookup[local.gcpRegion].longitude
  }
  cloud_credentials {
    name      = local.xc_gcp_cloud_credentials
    namespace = local.system_namespace
  }

  gcp_region              = local.gcpRegion
  instance_type           = local.instance_type
  logs_streaming_disabled = true
  ssh_key                 = coalesce(var.ssh_key, tls_private_key.key.public_key_openssh)

  ingress_egress_gw {
    gcp_certified_hw = "gcp-byol-multi-nic-voltmesh"
    node_number      = local.num_volterra_nodes
    gcp_zone_names   = local.zones
    #no_forward_proxy = true
    forward_proxy_allow_all  = false

    # TODO: Check FW policy
    # active_enhanced_firewall_policies {
    #   enhanced_firewall_policies {
    #     name = "${local.name}-enh-fw-pol"
    #   }
    # }

    // no_global_network        = true
    global_network_list {
        global_network_connections {
          slo_to_global_dr {
            global_vn {
              name = local.xc_global_vn_name
              namespace = "system"
            }
          }
        }
    }
    no_network_policy        = true
    no_inside_static_routes  = true
    no_outside_static_routes = true
    inside_network {
      existing_network {
        name = module.inside.network_name
      }
    }
    inside_subnet {
      existing_subnet {
        subnet_name = module.inside.subnets_names[0]
      }
    }
    outside_network {
      existing_network {
        name = module.outside.network_name
      }
    }
    outside_subnet {
      existing_subnet {
        subnet_name = module.outside.subnets_names[0]
      }
    }
  }

  offline_survivability_mode {
    enable_offline_survivability_mode = true
  }

  lifecycle {
    ignore_changes = [labels]
  }
  # These shouldn't be necessary, but lifecycle is flaky without them

  depends_on = [module.inside, module.outside]
}

resource "volterra_cloud_site_labels" "labels" {
  name             = volterra_gcp_vpc_site.perimeter.name
  site_type        = "gcp_vpc_site"
  labels           = local.tags
  ignore_on_delete = true

  depends_on = [
    volterra_gcp_vpc_site.perimeter
  ]
}

# Instruct Volterra to provision the GCP VPC site
resource "volterra_tf_params_action" "perimeter" {
  site_name        = volterra_gcp_vpc_site.perimeter.name
  site_kind        = "gcp_vpc_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false
  # These shouldn't be necessary, but lifecycle is flaky without them
  depends_on = [module.inside, module.outside, volterra_gcp_vpc_site.perimeter]
}