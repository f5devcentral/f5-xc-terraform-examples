#output "xc_lb_name" {
#  value = nonsensitive(volterra_http_loadbalancer.lb_https.name)
#}

output "endpoint" {
  value = var.app_domain
}
