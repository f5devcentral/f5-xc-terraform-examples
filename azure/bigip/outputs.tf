output "mgmtPublicIP" {
  value = module.bigip.*.mgmtPublicIP
}

output "mgmtPublicDNS" {
  value = module.bigip.*.mgmtPublicDNS
}

output "bigip_username" {
  value = module.bigip.*.f5_username
}

output "bigip_password" {
  value = module.bigip.*.bigip_password
}

output "mgmtPort" {
  value = module.bigip.*.mgmtPort
}

output "bigip_public_addresses" {
  value = module.bigip.*.public_addresses
}

output "bigip_private_addresses" {
  value = module.bigip.*.private_addresses
}

output "bigip_instance_ids" {
  value = module.bigip.*.bigip_instance_ids
}