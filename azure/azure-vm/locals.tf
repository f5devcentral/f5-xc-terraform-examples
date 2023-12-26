locals {
  azure_region        = data.tfe_outputs.infra.values.azure_region
  resource_group_name = data.tfe_outputs.infra.values.resource_group_name
  vnet_name           = data.tfe_outputs.infra.values.vnet_name
  subnet_name         = data.tfe_outputs.infra.values.subnet_name
  subnet_id           = data.tfe_outputs.infra.values.subnet_id
  project_prefix      = data.tfe_outputs.infra.values.project_prefix
  build_suffix        = data.tfe_outputs.infra.values.build_suffix
  vm_public_ip        = data.tfe_outputs.infra.values.vm_public_ip
}




