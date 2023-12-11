output "name" {
  value       = volterra_enhanced_firewall_policy.aws_fw_rules.name
  description = "Enhanced Firewall Policy Name"
}

output "namespace" {
  value       = volterra_enhanced_firewall_policy.aws_fw_rules.namespace
  description = "Enhanced Firewall Policy Namespace"
}