resource "volterra_cloud_credentials" "gcp_cred" {
  name      = format("%s-gcp-credentials", local.project_prefix)
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
  name                   = format("%s-gcp-site-%s", local.project_prefix, local.build_suffix)
  namespace              = "system"
  cloud_credentials {
    name                 = volterra_cloud_credentials.gcp_cred.name
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
        name             = local.gcp_vpc_name
      }
    }
    node_number          = 1
    local_subnet {
      existing_subnet {
        subnet_name      = local.gcp_vpc_subnet
      }
    }
  }
  lifecycle {
    ignore_changes       = [labels]
  }
}

resource "volterra_cloud_site_labels" "labels" {
  depends_on = [volterra_site_mesh_group.smg]
  name       = volterra_gcp_vpc_site.site.name
  site_type  = "gcp_vpc_site"
  labels     = {
    mcn_smg_label  = format("%s-label_value", local.project_prefix)
  }
  ignore_on_delete = true
}

resource "null_resource" "validation-wait-gcp" {
  depends_on       = [volterra_cloud_site_labels.labels]
  provisioner "local-exec" {
    command        = "sleep 70"
  }
}

resource "volterra_tf_params_action" "apply_gcp_vpc" {
  depends_on       = [null_resource.validation-wait-gcp]
  site_name        = volterra_gcp_vpc_site.site.name
  site_kind        = "gcp_vpc_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = true
}
