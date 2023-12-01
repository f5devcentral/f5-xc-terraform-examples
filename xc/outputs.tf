
output "xc_lb_name" {
  value = nonsensitive(volterra_http_loadbalancer.lb_https.name)
}
output "xc_waf_name" {
  value = nonsensitive(volterra_app_firewall.waap-tf.name)
}
output "endpoint" {
  value = var.app_domain
}
/*
output "az_ce_site_pub_ip" {
  value = var.az_ce_site ? data.azurerm_virtual_machine.az-ce-site[0].public_ip_address : null
}
