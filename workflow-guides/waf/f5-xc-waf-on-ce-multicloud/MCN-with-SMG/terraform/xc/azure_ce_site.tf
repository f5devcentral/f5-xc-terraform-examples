resource "volterra_cloud_credentials" "azure_cred" {
  name                      = format("%s-azure-credentials", local.project_prefix)
  namespace                 = "system"
  azure_client_secret {
    client_id               = "${var.azure_service_principal_appid}"
    client_secret {
      clear_secret_info {
        url                 = "string:///${base64encode(var.azure_service_principal_password)}"
      }
    }
    subscription_id         = "${var.azure_subscription_id}"
    tenant_id               = "${var.azure_subscription_tenant_id}"
  }
}

resource "volterra_azure_vnet_site" "azure_vnet_site" {
  name                      = format("%s-az-site-%s", local.project_prefix, local.build_suffix)
  namespace                 = "system"
  default_blocked_services  = true

 azure_cred {
    name                    = volterra_cloud_credentials.azure_cred.name
    namespace               = "system"
  }
  logs_streaming_disabled   = true
  azure_region              = local.azure_region
  resource_group            = format("%s-az-rgroup-%s", local.project_prefix, local.build_suffix)
  disk_size                 = 80
  machine_type              = var.azure_xc_machine_type

  ingress_gw {
    azure_certified_hw      = "azure-byol-voltmesh"
    az_nodes {
      azure_az              = "1"
      disk_size             = "80"
      local_subnet {
          subnet {
            subnet_name         = local.azure_subnet_name
            vnet_resource_group = true
          }			
      }
    }
  }

  vnet {
    existing_vnet {
      resource_group       = local.azure_resource_group
      vnet_name            = local.azure_vnet_name
    }
  }

  lifecycle {
    ignore_changes        = [labels]
  }
  ssh_key                 = var.ssh_key
}

resource "volterra_cloud_site_labels" "labels" {
  depends_on              = [volterra_site_mesh_group.smg]
  name                    = volterra_azure_vnet_site.azure_vnet_site.name
  site_type               = "azure_vnet_site"
  labels = {
    mcn_smg_label         = format("%s-label_value", local.project_prefix)
  }
  ignore_on_delete        = true
}

resource "null_resource" "validation-wait" {
  depends_on              = [volterra_cloud_site_labels.labels]
  provisioner "local-exec" {
    command               = "sleep 70"
  }
}

resource "volterra_tf_params_action" "action_apply" {
  depends_on      = [null_resource.validation-wait]
  site_name       = volterra_azure_vnet_site.azure_vnet_site.name
  site_kind       = "azure_vnet_site"
  action          = "apply"
  wait_for_action = true
}
