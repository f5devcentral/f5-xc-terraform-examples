locals {
  gcp_region          = data.tfe_outputs.infra.values.gcp_region
  vpc_name            = data.tfe_outputs.infra.values.vpc_name
  subnet_name         = data.tfe_outputs.infra.values.vpc_subnet
  project_prefix      = data.tfe_outputs.infra.values.project_prefix
  build_suffix        = data.tfe_outputs.infra.values.build_suffix
  gcp_project_id      = data.tfe_outputs.infra.values.gcp_project_id
}
