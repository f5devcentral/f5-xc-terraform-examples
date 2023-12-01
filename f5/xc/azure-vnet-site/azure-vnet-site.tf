module "azure_vnet_site" {
  source                             = "f5devcentral/azure-vnet-site/xc"
  version                            = "0.0.2"
  site_name                          = ("" != var.prefix) ? format("%s-%s", var.prefix, var.name) : var.name
  azure_rg_name                      = ("" != var.prefix) ? format("%s-%s", var.prefix, var.azure_rg_name) : var.azure_rg_name
  site_description                   = ("" != var.site_description) ? var.site_description : ""
  site_namespace                     = ("" != var.site_namespace) ? var.site_namespace : "system"
  tags                               = ("" != var.tags) ? jsondecode(var.tags) : {}
  offline_survivability_mode         = ("" != var.offline_survivability_mode) ? tobool(var.offline_survivability_mode) : false
  software_version                   = ("" != var.software_version) ? var.software_version : null
  operating_system_version           = ("" != var.operating_system_version) ? var.operating_system_version : null
  site_type                          = ("" != var.site_type) ? var.site_type : null
  master_nodes_az_names              = var.master_nodes_az_names
  nodes_disk_size                    = ("" != var.nodes_disk_size) ? tonumber(var.nodes_disk_size) : 80
  ssh_key                            = ("" != var.ssh_key) ? var.ssh_key : null
  azure_rg_location                  = ("" != var.azure_rg_location) ? var.azure_rg_location : null
  machine_type                       = ("" != var.machine_type) ? var.machine_type : "Standard_D3_v2"
  az_cloud_credentials_name          = var.az_cloud_credentials_name
  az_cloud_credentials_namespace     = ("" != var.az_cloud_credentials_namespace) ? var.az_cloud_credentials_namespace : null
  az_cloud_credentials_tenant        = ("" != var.az_cloud_credentials_tenant) ? var.az_cloud_credentials_tenant : null
  jumbo                              = ("" != var.jumbo) ? tobool(var.jumbo) : null
  log_receiver                       = ("" != var.log_receiver) ? jsondecode(var.log_receiver) : null
  vnet_name                          = ("" != var.vnet_name) ? var.vnet_name : null
  vnet_rg_name                       = ("" != var.vnet_rg_name) ? var.vnet_rg_name : null
  vnet_rg_location                   = ("" != var.vnet_rg_location) ? var.vnet_rg_location : null
  vnet_cidr                          = ("" != var.vnet_cidr) ? var.vnet_cidr : null
  apply_outside_sg_rules             = ("" != var.apply_outside_sg_rules) ? var.apply_outside_sg_rules : true
  existing_inside_rt_names           = var.existing_inside_rt_names
  existing_local_subnets             = var.existing_local_subnets
  existing_inside_subnets            = var.existing_inside_subnets
  existing_outside_subnets           = var.existing_outside_subnets
  local_subnets                      = var.local_subnets
  inside_subnets                     = var.inside_subnets
  outside_subnets                    = var.outside_subnets
  local_subnets_ipv6                 = var.local_subnets_ipv6
  inside_subnets_ipv6                = var.inside_subnets_ipv6
  outside_subnets_ipv6               = var.outside_subnets_ipv6
  worker_nodes_per_az                = ("" != var.worker_nodes_per_az) ? tonumber(var.worker_nodes_per_az) : 0
  block_all_services                 = ("" != var.block_all_services) ? tobool(var.block_all_services) : true
  blocked_service                    = ("" != var.blocked_service) ? jsondecode(var.blocked_service) : null
  apply_action_wait_for_action       = ("" != var.apply_action_wait_for_action) ? tobool(var.apply_action_wait_for_action) : true
  apply_action_ignore_on_update      = ("" != var.apply_action_ignore_on_update) ? tobool(var.apply_action_ignore_on_update) : true
  dc_cluster_group_inside_vn         = ("" != var.dc_cluster_group_inside_vn) ? jsondecode(var.dc_cluster_group_inside_vn) : null
  dc_cluster_group_outside_vn        = ("" != var.dc_cluster_group_outside_vn) ? jsondecode(var.dc_cluster_group_outside_vn) : null
  active_forward_proxy_policies_list = ("" != var.active_forward_proxy_policies_list) ? var.active_forward_proxy_policies_list : null
  forward_proxy_allow_all            = ("" != var.forward_proxy_allow_all) ? tobool(var.forward_proxy_allow_all) : null
  global_network_connections_list    = ("" != var.global_network_connections_list) ? var.global_network_connections_list : null
  inside_static_route_list           = ("" != var.inside_static_route_list) ? var.inside_static_route_list : null
  outside_static_route_list          = ("" != var.outside_static_route_list) ? var.outside_static_route_list : null
  enhanced_firewall_policies_list    = ("" != var.enhanced_firewall_policies_list) ? var.enhanced_firewall_policies_list : null
  active_network_policies_list       = ("" != var.active_network_policies_list) ? var.active_network_policies_list : null
  sm_connection_public_ip            = ("" != var.sm_connection_public_ip) ? tobool(var.sm_connection_public_ip) : true
}