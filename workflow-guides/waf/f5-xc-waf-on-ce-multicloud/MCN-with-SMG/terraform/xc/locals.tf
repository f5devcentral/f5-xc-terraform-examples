locals {
  project_prefix      = try(data.tfe_outputs.infra.0.values.project_prefix, var.xc_project_prefix)
  build_suffix        = try(data.tfe_outputs.infra.0.values.build_suffix, resource.random_id.build_suffix.0.hex)
  origin_bigip        = try(data.tfe_outputs.bigip[0].values.bigip_public_vip, "")
  dns_origin_pool     = local.origin_nginx != "" ? true : false
  kubeconfig          = try(data.tfe_outputs.aks-cluster[0].values.kube_config, "")
  azure_region        = try(data.tfe_outputs.infra.0.values.azure_region, "")
  resource_group_name = try(data.tfe_outputs.infra.0.values.resource_group_name, "")
  vnet_name           = try(data.tfe_outputs.infra.0.values.vnet_name, "")
  subnet_name         = try(data.tfe_outputs.infra.0.values.subnet_name, data.tfe_outputs.infra.0.values.vpc_subnet, "")
  subnet_id           = try(data.tfe_outputs.infra.0.values.subnet_id, "")
  gcp_region          = try(data.tfe_outputs.infra.0.values.gcp_region, "")
}
