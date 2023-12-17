variable "gcp_instance_type" {
  default = "n1-standard-4"
}

resource "volterra_cloud_credentials" "gcp_cred" {
  count     = var.gcp_ce_site ? 1 : 0
  name      = "${local.project_prefix}-gcp-credentials"
  namespace = "system"
  gcp_cred_file {
    credential_file {
      clear_secret_info {
        url = format("string:///%s", base64encode(var.GOOGLE_CREDENTIALS))
      }
    }
  }
}

resource "volterra_gcp_vpc_site" "site" {
  depends_on             = [volterra_cloud_credentials.gcp_cred]
  name                   = var.site_name
  namespace              = "system"
  cloud_credentials {
    name                 = volterra_cloud_credentials.gcp_cred[0].name
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

resource "null_resource" "check_site_status_cert" {
  count         = var.gcp_ce_site == "true" ? 1 : 0
  provisioner "local-exec" {
    command     = format("bash ${path.module}/check_ce_status.sh config/namespaces/system/sites/%s api.p12 %s 3600 cert $VES_P12_PASSWORD", var.site_name, var.xc_tenant)
    #interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}
