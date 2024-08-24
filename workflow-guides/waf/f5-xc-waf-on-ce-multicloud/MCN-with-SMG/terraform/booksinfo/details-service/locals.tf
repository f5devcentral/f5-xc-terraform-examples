locals {
  project_prefix          = data.tfe_outputs.azure-infra.values.project_prefix
  build_suffix            = data.tfe_outputs.azure-infra.values.build_suffix
  resource_group_name     = data.tfe_outputs.azure-infra.values.resource_group_name
}
