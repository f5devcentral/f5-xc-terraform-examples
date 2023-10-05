
output "xc_lb_name" {
  value = volterra_http_loadbalancer.lb_https.name
}
output "endpoint" {
  value = var.app_domain
}
