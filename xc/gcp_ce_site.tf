variable "gcp_instance_type" {
  default = "n1-standard-4"
}

/*
resource "volterra_cloud_credentials" "gcp_cred" {
  count     = var.gcp_ce_site ? 1 : 0
  name      = "${local.project_prefix}-gcp-credentials"
  namespace = "system"
  gcp_cred_file {
    credential_file {
      clear_secret_info {
        url = format("string:///%s", base64encode("${var.GOOGLE_CREDENTIALS}"))
      }
    }
  }
}
*/

resource "volterra_gcp_vpc_site" "site" {
  #depends_on             = [volterra_cloud_credentials.gcp_cred]
  name                   = "${local.project_prefix}-gcp-site"
  namespace              = "system"
  cloud_credentials {
    name                 = "jani-gcp"
    namespace            = "system"
  }
  ssh_key                = var.ssh_key
  gcp_region             = local.gcp_region
  instance_type          = var.gcp_instance_type
  ingress_gw {
    gcp_certified_hw     = "gcp-byol-voltmesh"
    gcp_zone_names       = ["${local.gcp_region}-a"]
    local_network {
      existing_network {
        name             = local.vpc_name
      }
    }
    node_number          = 1
    local_subnet {
      existing_subnet {
        subnet_name      = local.subnet_name
      }
    }
  }
  lifecycle {
    ignore_changes       = [labels]
  }
}

resource "volterra_tf_params_action" "apply_gcp_vpc" {
  site_name        = volterra_gcp_vpc_site.site.name
  site_kind        = "gcp_vpc_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = true
}
