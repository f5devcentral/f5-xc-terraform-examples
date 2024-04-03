resource "volterra_cloud_credentials" "azure_cred" {
  count = var.az_ce_site ? 1 : 0
  name      = format("%s-az-creds-%s", local.project_prefix, local.build_suffix)
  namespace = "system"
  azure_client_secret {
    client_id = "${var.azure_service_principal_appid}"
    client_secret {
      clear_secret_info {
        url = "string:///${base64encode(var.azure_service_principal_password)}"
      }
    }
    subscription_id = "${var.azure_subscription_id}"
    tenant_id       = "${var.azure_subscription_tenant_id}"
  }
}

resource "volterra_azure_vnet_site" "azure_vnet_site" {
  count = var.az_ce_site ? 1 : 0
  name      = local.project_prefix
  namespace = "system"

  default_blocked_services = true

 azure_cred {
    name      = volterra_cloud_credentials.azure_cred[0].name
    namespace = "system"
  }
  logs_streaming_disabled = true
  azure_region   = local.azure_region
  resource_group = format("%s-rg-xc-%s", local.project_prefix, local.build_suffix)

  disk_size = 80
  machine_type = var.azure_xc_machine_type

  ingress_gw {
    azure_certified_hw = "azure-byol-voltmesh"
    az_nodes {
      azure_az  = "1"
      disk_size = "80"
      local_subnet {
          subnet {
            subnet_name         = local.subnet_name
                  vnet_resource_group = true
          }			
      }
    }
  }

  vnet {
    existing_vnet {
      resource_group = local.resource_group_name
      vnet_name      = local.vnet_name
    }
  }

  lifecycle {
    ignore_changes = [labels]
  }
  ssh_key = var.ssh_key
}

resource "null_resource" "validation-wait" {
  count = var.az_ce_site ? 1 : 0
  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "volterra_tf_params_action" "action_apply" {
  count = var.az_ce_site ? 1 : 0
  depends_on      = [null_resource.validation-wait]
  site_name       = volterra_azure_vnet_site.azure_vnet_site[0].name
  site_kind       = "azure_vnet_site"
  action          = "apply"
  wait_for_action = true
}
