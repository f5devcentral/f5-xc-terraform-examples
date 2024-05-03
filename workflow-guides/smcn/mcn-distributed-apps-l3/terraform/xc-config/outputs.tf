output "xc_virtual_site" {
  description = "name of virtual site across all clouds"
  value       = volterra_virtual_site.site.name
}

output "xc_global_vn" {
  description = "Name of the F5XC Global Network"
  value       = volterra_virtual_network.global_vn.name
}

output "xc_enhanced_firewall_policy" {
  description = "Name of the F5XC Global Network"
  value       = volterra_enhanced_firewall_policy.mcn_nc_efp.name
}

output "tags" {
  description = "Tags for resources"
  value       = local.commonLabels
}