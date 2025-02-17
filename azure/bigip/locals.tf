locals {
  azure_region        = data.tfe_outputs.azure-infra.values.azure_region
  resource_group_name = data.tfe_outputs.azure-infra.values.resource_group_name
  vnet_name           = data.tfe_outputs.azure-infra.values.vnet_name
  subnet_name         = data.tfe_outputs.azure-infra.values.subnet_name
  subnet_id           = data.tfe_outputs.azure-infra.values.subnet_id
  project_prefix      = data.tfe_outputs.azure-infra.values.project_prefix
  build_suffix        = data.tfe_outputs.azure-infra.values.build_suffix
  app_ip              = data.tfe_outputs.aks-cluster.values.app_external_ip
  aks_resource_group_name = format("MC_%s-rg-%s_%s-aks-%s_%s", local.project_prefix, local.build_suffix,local.project_prefix, local.build_suffix,local.azure_region)
  azure_subnet_cidr   = data.tfe_outputs.azure-infra.values.azure_subnet_cidr
  aks_subnet_id       = data.tfe_outputs.aks-cluster.values.aks_subnet_id
}