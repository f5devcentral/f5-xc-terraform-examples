output "bigip_ip" {
  value       = local.bigip_ip
  sensitive   = true
  description = "BIGIP Public IP"
}
