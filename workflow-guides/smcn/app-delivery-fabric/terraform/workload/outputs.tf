output "aws_xc_node_outside_ip" {
  value = local.aws_xc_node_outside_ip
  description = "AWS XC node public IP"
}

output "aws_xc_node_inside_ip" {
  value = local.aws_xc_node_inside_ip
  description = "AWS XC node internal IP"
}

output "product_domain" {
  value = local.app_domain
  description = "Product domain"
}

output "details_domain" {
  value = local.details_domain
  description = "Details domain"
}

output "xc_namespace" {
  value = local.xc_namespace
  description = "XC namespace"
}

output "product_loadbalancer_name" {
  value = volterra_http_loadbalancer.bookinfo_product.name
  description = "Product loadbalancer name"
}

output "details_loadbalancer_name" {
  value = volterra_http_loadbalancer.bookinfo_details.name
  description = "Details loadbalancer name"
}