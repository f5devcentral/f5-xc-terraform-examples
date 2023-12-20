resource "volterra_discovery" "svc-discovery" {
  count       = var.xc_service_discovery ? 1 : 0
  depends_on  = [volterra_tf_params_action.action_apply]
  name        = format("%s-sd-%s", local.project_prefix, local.build_suffix)
  namespace   = "system"

  discovery_k8s {
     access_info {
       kubeconfig_url {
         clear_secret_info {
           url = "string:///${base64encode(local.kubeconfig)}"
         }
       }
     }
    publish_info {
      disable = true
    }
  }

  where {
    site {
      ref {
        name = local.project_prefix
        namespace = "system"
      }
    network_type = "VIRTUAL_NETWORK_SITE_LOCAL"
     }
  }
}
