resource "bigip_ltm_monitor" "monitor" {
  name                    = "/Common/terraform_monitor1"
  parent                  = "/Common/tcp"
}

resource "bigip_ltm_node" "node" {
  name                    = "/Common/airline_node"
  address                 = local.app_ip
  monitor                 = "none"
  description             = "Terraform-Node"
}

resource "bigip_ltm_pool" "pool" {
  name                      = "/Common/airline_Pool"
  load_balancing_mode       = "round-robin"
  minimum_active_members    = 1
  monitors                  = [bigip_ltm_monitor.monitor.parent]
}

resource "bigip_ltm_pool_attachment" "attach_node" {
  pool                      = bigip_ltm_pool.pool.name
  node                      = "${bigip_ltm_node.node.name}:80"
}


## CREATING XC BOT DFEENSE PROFILE ON BIGIP
#
#resource "bigip_ltm_monitor" "monitor2" {
#  name                    = "/Common/terraform_monitor_bd"
#  parent                  = "/Common/http"
#}
#
#resource "bigip_ltm_node" "node2" {
#  name                    = "/Common/terraform_node_bd"
#  address                 = "ibd-webus.fastcache.net"
#  monitor                 = "none"
#  description             = "Terraform-Node-Bot-Defense"
#}
#
#resource "bigip_ltm_pool" "pool2" {
#  name                      = "/Common/terraform_protection_pool"
#  load_balancing_mode       = "round-robin"
#  minimum_active_members    = 1
#  monitors                  = [bigip_ltm_monitor.monitor2.parent]
#}
#
#resource "bigip_saas_bot_defense_profile" "test-bot-defense" {
#  name                    = "/Common/test_xc_bot_defense"
#  application_id          = var.application_id
#  tenant_id               = var.tenant_id
#  api_key                 = var.api_key
#  shape_protection_pool   = bigip_ltm_pool.pool2.name
#  ssl_profile             = "/Common/cloud-service-default-ssl"
#  protected_endpoints {
#    name                  = "p_endpoint"
#    host                  = local.bigip_ip
#    endpoint              = "/login"
#    post                  = "enabled"
#    put                   = "enabled"
#    mitigation_action     = "block"
#  }
#}
#
#resource "bigip_ltm_pool_attachment" "attach_node2" {
#  pool                      = bigip_ltm_pool.pool2.name
#  node                      = "${bigip_ltm_node.node2.name}:443"
#}
#
## BINDING AIRLINE APP & XC BOT PROFILE TO VIRTUAL SERVER
#
#resource "bigip_ltm_virtual_server" "https_bd" {
#  name                        = "/Common/terraform_bot_vs"
#  destination                 = local.bigip_private
#  description                 = "VS-terraform-xc-bot"
#  port                        = 80
#  pool                        = bigip_ltm_pool.pool.name
#  profiles                    = ["/Common/http", bigip_saas_bot_defense_profile.test-bot-defense.name]
#  client_profiles             = ["/Common/tcp"]
#  server_profiles             = ["/Common/tcp-lan-optimized"]
#  persistence_profiles        = ["/Common/source_addr", "/Common/hash"]
#  source_address_translation  = "automap"
#  translate_address           = "enabled"
#  translate_port              = "enabled"
#}