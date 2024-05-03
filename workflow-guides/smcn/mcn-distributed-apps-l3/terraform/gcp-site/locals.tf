locals {
    name                          = ("" != var.prefix) ? format("%s-%s", var.prefix, var.name) : var.name
    gcpProjectId                  = var.gcp_project_id
    gcpRegion                     = var.gcp_region
    system_namespace              = "system"
    tags                          = var.tags
    num_volterra_nodes            = 1
    instance_type                 = "n1-standard-4"
    zones                         = (null != var.zones) ? var.zones : [element(random_shuffle.zones.result, 0)]
    xc_gcp_credentials            = base64decode(var.xc_gcp_credentials)
    xc_gcp_cloud_credentials      = ("" != var.xc_gcp_cloud_credentials) ? var.xc_gcp_cloud_credentials : element(volterra_cloud_credentials.gcp, 0).name
    allowed_remote_networks_cidr  = [ "10.0.0.0/8" ]
    allowed_health_check_sources  = [ "35.191.0.0/16", "130.211.0.0/22" ]
    sli_cird                      = var.sli_cird
    slo_cidr                      = var.slo_cidr
    proxy_cidr                    = var.proxy_cidr
    xc_global_vn_name             = var.xc_global_vn_name
}