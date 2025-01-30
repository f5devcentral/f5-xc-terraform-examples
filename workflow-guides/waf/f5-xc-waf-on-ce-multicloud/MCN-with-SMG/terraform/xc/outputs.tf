output "endpoint" {
  value = var.app_domain
}

output "gcp_ce_privateip" {
  value = local.gcp_ce_details.2
}

output "gcp_ce_instanceid" {
  value = local.gcp_ce_details.0
}
