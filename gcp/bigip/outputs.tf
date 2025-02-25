output "bigip_public_ip" {
  value       = nonsensitive(module.bigip.*.mgmtPublicIP)
  description = "BIGIP Public IP"
}

output "bigip_password" {
  value       = nonsensitive(module.bigip.*.bigip_password)
  description = "BIGIP Password"
}

output "bigip_instance_id" {
  value       = nonsensitive(module.bigip.*.bigip_instance_ids)
  description = "BIGIP Instance Id's"
}

output "bigip_private_addresses" {
  value       = nonsensitive(module.bigip.*.private_addresses)
  description = "BIGIP Private addresses"
}

output "bigip_public_addresses" {
  value       = nonsensitive(module.bigip.*.public_addresses)
  description = "BIGIP public addresses"
}

output "app_ip" {
  value       = local.app_ip
  description = "App load balancer external IP address."
  sensitive   = true
}
