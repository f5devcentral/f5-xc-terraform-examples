output "ssh_private_key" {
  value       = tls_private_key.key.private_key_openssh
  sensitive   = true
  description = "SSH private key for accessing VMs"
}

output "azure_vm_public_ip" {
  value       = azurerm_public_ip.ip.ip_address
  description = "Azure VM Public IP"
}

output "azure_vm_private_ip" {
  value       = var.azure_vm_private_ip
  description = "Azure VM Private IP"
}

output "aws_vm_private_ip" {
  value       = var.aws_vm_private_ip
  description = "AWS VM Private IP"
}

output "global_vn_name" {
  value       = volterra_virtual_network.global_vn.name
  description = "Global VN Name"
}

output "global_vn_namespace" {
  value       = volterra_virtual_network.global_vn.namespace
  description = "Global VN Namespace"
}

output "ssh_host" {
  value       = format("ves-io-%s.ac.vh.ves.io", volterra_tcp_loadbalancer.azure_ssh_access.id)
  description = "SSH Host"
}

output "ssh_port" {
  value       = random_integer.ssh_port.result
  description = "SSH Port"
}
