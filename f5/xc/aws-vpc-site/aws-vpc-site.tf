module "aws_vpc_site" {
  source = "github.com/f5shemyakin/terraform-xc-aws-vpc-site"
  # source                                   = "f5devcentral/aws-vpc-site/xc"
  # version                                  = "0.0.11"
  site_name                                = ("" != var.prefix) ? format("%s-%s", var.prefix, var.name) : var.name
  aws_region                               = var.aws_region
  aws_cloud_credentials_name               = var.aws_cloud_credentials_name
  aws_cloud_credentials_namespace          = ("" != var.aws_cloud_credentials_namespace) ? var.aws_cloud_credentials_namespace : null
  aws_cloud_credentials_tenant             = ("" != var.aws_cloud_credentials_tenant) ? var.aws_cloud_credentials_tenant : null
  site_description                         = ("" != var.site_description) ? var.site_description : null
  site_namespace                           = ("" != var.site_namespace) ? var.site_namespace : "system"
  tags                                     = ("" != var.tags) ? jsondecode(var.tags) : {}
  offline_survivability_mode               = ("" != var.offline_survivability_mode) ? tobool(var.offline_survivability_mode) : false
  software_version                         = ("" != var.software_version) ? var.software_version : null
  operating_system_version                 = ("" != var.operating_system_version) ? var.operating_system_version : null
  site_type                                = ("" != var.site_type) ? var.site_type : null
  master_nodes_az_names                    = var.master_nodes_az_names
  nodes_disk_size                          = ("" != var.nodes_disk_size) ? tonumber(var.nodes_disk_size) : 80
  ssh_key                                  = ("" != var.ssh_key) ? var.ssh_key : null
  instance_type                            = ("" != var.instance_type) ? var.instance_type : "t3.xlarge"
  jumbo                                    = ("" != var.jumbo) ? tobool(var.jumbo) : null
  direct_connect                           = ("" != var.direct_connect) ? jsondecode(var.direct_connect) : null
  egress_nat_gw                            = ("" != var.egress_nat_gw) ? jsondecode(var.egress_nat_gw) : null
  egress_virtual_private_gateway           = ("" != var.egress_virtual_private_gateway) ? jsondecode(var.egress_virtual_private_gateway) : null
  enable_internet_vip                      = ("" != var.enable_internet_vip) ? tobool(var.enable_internet_vip) : false
  allowed_vip_port                         = ("" != var.allowed_vip_port) ? jsondecode(var.allowed_vip_port) : { disable_allowed_vip_port = true }
  log_receiver                             = ("" != var.log_receiver) ? jsondecode(var.log_receiver) : null
  vpc_id                                   = ("" != var.vpc_id) ? var.vpc_id : null
  vpc_cidr                                 = ("" != var.vpc_cidr) ? var.vpc_cidr : null
  create_aws_vpc                           = ("" != var.create_aws_vpc) ? tobool(var.create_aws_vpc) : true
  custom_security_group                    = ("" != var.custom_security_group) ? jsondecode(var.custom_security_group) : null
  existing_local_subnets                   = var.existing_local_subnets
  existing_inside_subnets                  = var.existing_inside_subnets
  existing_outside_subnets                 = var.existing_outside_subnets
  existing_workload_subnets                = var.existing_workload_subnets
  local_subnets                            = var.local_subnets
  inside_subnets                           = var.inside_subnets
  outside_subnets                          = var.outside_subnets
  workload_subnets                         = var.workload_subnets
  worker_nodes_per_az                      = ("" != var.worker_nodes_per_az) ? tonumber(var.worker_nodes_per_az) : 0
  block_all_services                       = ("" != var.block_all_services) ? tobool(var.block_all_services) : true
  blocked_service                          = ("" != var.blocked_service) ? jsondecode(var.blocked_service) : null
  apply_action_wait_for_action             = ("" != var.apply_action_wait_for_action) ? tobool(var.apply_action_wait_for_action) : true
  apply_action_ignore_on_update            = ("" != var.apply_action_ignore_on_update) ? tobool(var.apply_action_ignore_on_update) : true
  dc_cluster_group_inside_vn               = ("" != var.dc_cluster_group_inside_vn) ? jsondecode(var.dc_cluster_group_inside_vn) : null
  dc_cluster_group_outside_vn              = ("" != var.dc_cluster_group_outside_vn) ? jsondecode(var.dc_cluster_group_outside_vn) : null
  active_forward_proxy_policies_list       = ("" != var.active_forward_proxy_policies_list) ? var.active_forward_proxy_policies_list : null
  forward_proxy_allow_all                  = ("" != var.forward_proxy_allow_all) ? tobool(var.forward_proxy_allow_all) : null
  global_network_connections_list          = ("" != var.global_network_connections_list) ? var.global_network_connections_list : null
  inside_static_route_list                 = ("" != var.inside_static_route_list) ? var.inside_static_route_list : null
  outside_static_route_list                = ("" != var.outside_static_route_list) ? var.outside_static_route_list : null
  enhanced_firewall_policies_list          = ("" != var.enhanced_firewall_policies_list) ? var.enhanced_firewall_policies_list : null
  active_network_policies_list             = ("" != var.active_network_policies_list) ? var.active_network_policies_list : null
  sm_connection_public_ip                  = ("" != var.sm_connection_public_ip) ? tobool(var.sm_connection_public_ip) : true
  vpc_instance_tenancy                     = ("" != var.vpc_instance_tenancy) ? var.vpc_instance_tenancy : "default"
  vpc_enable_dns_hostnames                 = ("" != var.vpc_enable_dns_hostnames) ? tobool(var.vpc_enable_dns_hostnames) : true
  vpc_enable_dns_support                   = ("" != var.vpc_enable_dns_support) ? tobool(var.vpc_enable_dns_support) : true
  vpc_enable_network_address_usage_metrics = ("" != var.vpc_enable_network_address_usage_metrics) ? tobool(var.vpc_enable_network_address_usage_metrics) : false
}
