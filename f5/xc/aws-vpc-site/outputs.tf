output "name" {
  description = "Name of the configured AWS VPC Site."
  value       = module.aws_vpc_site.name
}

output "id" {
  description = "ID of the configured AWS VPC Site."
  value       = module.aws_vpc_site.id
}

#-----------------------------------------------------
# SSH Key
#-----------------------------------------------------

output "ssh_private_key_pem" {
  description = "AWS VPC Site generated private key."
  value       = module.aws_vpc_site.ssh_private_key_pem
  sensitive   = true
}

output "ssh_private_key_openssh" {
  description = "AWS VPC Site generated OpenSSH private key."
  value       = module.aws_vpc_site.ssh_private_key_openssh
  sensitive   = true
}

output "ssh_public_key" {
  description = "AWS VPC Site public key."
  value       = module.aws_vpc_site.ssh_public_key
}

#-----------------------------------------------------
# AWS Site apply action output parameters
#-----------------------------------------------------

output "apply_tf_output" {
  description = "AWS Site apply terraform output parameter."
  value       = module.aws_vpc_site.apply_tf_output
}

output "apply_tf_output_map" {
  description = "AWS Site apply terraform output parameter."
  value       = module.aws_vpc_site.apply_tf_output_map
}

#-----------------------------------------------------
# AWS VPC Network output parameters
#-----------------------------------------------------

output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.aws_vpc_site.vpc_id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC."
  value       = module.aws_vpc_site.vpc_cidr
}

output "outside_subnet_ids" {
  description = "The IDs of the outside subnets."
  value       = module.aws_vpc_site.outside_subnet_ids
}

output "outside_route_table_ids" {
  description = "The IDs of the outside route tables."
  value       = module.aws_vpc_site.outside_route_table_ids
}

output "inside_subnet_ids" {
  description = "The IDs of the inside subnets."
  value       = module.aws_vpc_site.inside_subnet_ids
}

output "inside_route_table_ids" {
  description = "The IDs of the inside route tables."
  value       = module.aws_vpc_site.inside_route_table_ids
}

output "workload_subnet_ids" {
  description = "The IDs of the workload subnets."
  value       = module.aws_vpc_site.workload_subnet_ids
}

output "workload_route_table_ids" {
  description = "The IDs of the workload route tables."
  value       = module.aws_vpc_site.workload_route_table_ids
}

output "local_subnet_ids" {
  description = "The IDs of the local subnets."
  value       = module.aws_vpc_site.local_subnet_ids
}

output "local_route_table_ids" {
  description = "The IDs of the local route tables."
  value       = module.aws_vpc_site.local_route_table_ids
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway."
  value       = module.aws_vpc_site.internet_gateway_id
}

output "outside_security_group_id" {
  description = "The ID of the outside security group."
  value       = module.aws_vpc_site.outside_security_group_id
}
  
output "inside_security_group_id" {
  description = "The ID of the inside security group."
  value       =  module.aws_vpc_site.inside_security_group_id
}