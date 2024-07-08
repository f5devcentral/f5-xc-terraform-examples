# v1.0.34 volterra provider doesn't support nonsensitive funxn so removed them
output "xc_lb_name" {
  value = nonsensitive(volterra_http_loadbalancer.lb_https.name)
}
output "xc_waf_name" {
  value = volterra_app_firewall.waap-tf.name
}
output "endpoint" {
  value = var.app_domain
}
output "az_ce_site_pub_ip" {
  value = var.az_ce_site ? regex("master_public_ip_address = \"((?:\\d{1,3}\\.){3}\\d{1,3})\"", volterra_tf_params_action.action_apply[0].tf_output) : null
}
output "lb_cname" {
  value = volterra_http_loadbalancer.lb_https.cname
}
