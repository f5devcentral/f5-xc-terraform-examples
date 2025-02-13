resource "bigip_ltm_monitor" "monitor" {
  name                    = "/Common/terraform_monitor1"
  parent                  = "/Common/tcp"
}

resource "bigip_ltm_node" "app-node" {
  name                    = "/Common/application_node"
  address                 = local.app_ip
  monitor                 = "none"
  description             = "Terraform-Node"
}

resource "bigip_ltm_pool" "app-pool" {
  name                      = "/Common/app_Pool1"
  load_balancing_mode       = "round-robin"
  minimum_active_members    = 1
  monitors                  = [bigip_ltm_monitor.monitor.parent]
}

resource "bigip_ltm_pool_attachment" "attach_node" {
  pool                      = bigip_ltm_pool.app-pool.name
  node                      = "${bigip_ltm_node.app-node.name}:80"
}

resource "bigip_ltm_virtual_server" "http" {
  name                       = "/Common/application_vs"
  destination                = local.bigip_private
  description                = "VS-terraform"
  port                       = 80
  pool                       = bigip_ltm_pool.app-pool.name
  profiles                   = ["/Common/tcp", "/Common/http"]
  source_address_translation = "automap"
  translate_address          = "enabled"
  translate_port             = "enabled"
}


## CREATING XC BOT DFEENSE PROFILE ON BIGIP
#
#resource "bigip_ltm_monitor" "monitor2" {
#  name                    = "/Common/terraform_monitor_bd"
#  parent                  = "/Common/http"
#}
#
#resource "bigip_ltm_node" "node2" {
#  name                    = "/Common/ibd-webus.fastcache.net"
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
#    host                  = "4.155.79.249"
#    #path                  = "/user/signin"
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
## BINDING THE XC BOT PROFILE TO VIRTUAL SERVER
#
#resource "bigip_ltm_virtual_server" "https_bd" {
#  name                        = "/Common/terraform_vs2"
#  destination                 = local.app_ip
#  description                 = "VS-terraform-xc-bot"
#  port                        = 443
#  #bot_defense                 = "enabled"
#  pool                        = bigip_ltm_pool.pool2.name
#  profiles                    = ["/Common/http", bigip_saas_bot_defense_profile.test-bot-defense.name]
#  client_profiles             = ["/Common/tcp"]
#  server_profiles             = ["/Common/tcp-lan-optimized"]
#  persistence_profiles        = ["/Common/source_addr", "/Common/hash"]
#  source_address_translation  = "automap"
#  translate_address           = "enabled"
#  translate_port              = "enabled"
#}