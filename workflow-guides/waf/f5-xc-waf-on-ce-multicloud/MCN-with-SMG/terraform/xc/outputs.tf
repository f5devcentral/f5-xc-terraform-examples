output "endpoint" {
  value = var.app_domain
}

output "gcp_ce_privateip" {
  value = local.gcp_ce_ip.2
}
