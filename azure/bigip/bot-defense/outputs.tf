output "bigip_public_ip" {
  value       = local.bigip_public_ip
  sensitive   = true
  description = "BIGIP Public IP"
}