output "network_name_inside" {
  description = "The name for inside subnet"
  value = nonsensitive(module.inside.network_name)
}

output "network_name_outside" {
  description = "The name for outside subnet"
  value = nonsensitive(module.outside.network_name)
}

output "subnet_name_inside" {
  description = "The name for inside subnet"
  value = nonsensitive(module.inside.subnets_names[0])
}

output "subnet_name_outside" {
  description = "The name for outside subnet"
  value = nonsensitive(module.outside.subnets_names[0])
}
