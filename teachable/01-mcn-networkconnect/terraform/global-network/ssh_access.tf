resource "random_integer" "ssh_port" {
  min = 9000
  max = 9999
}

resource "volterra_tcp_loadbalancer" "azure_ssh_access" {
  name      = format("azure-%s-ssh", local.workload_name)
  namespace = "default"

  listen_port = random_integer.ssh_port.result

  advertise_on_public_default_vip = true
  retract_cluster                 = true
  hash_policy_choice_round_robin  = true
  tcp = true
  no_service_policies = true
  no_sni = true

  origin_pools_weights {
    weight   = 1
    priority = 1
    pool {
      name = volterra_origin_pool.azure_ssh_access.name
    }
  }
}

resource "volterra_origin_pool" "azure_ssh_access" {
  name                   = format("azure-%s-ssh", local.workload_name)
  namespace              = "default"
  endpoint_selection     = "ROUND_ROBIN"
  loadbalancer_algorithm = "LB_OVERRIDE"
  port                   = "22"
  no_tls                 = true

  origin_servers {
    private_ip {
      inside_network = true
      ip             = var.azure_vm_private_ip

      site_locator {
        site {
          name      = var.azure_site_name
          namespace = "system"
        }
      }
    }
  }
}