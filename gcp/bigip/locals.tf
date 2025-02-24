locals {
  project_id      = data.tfe_outputs.gcp-infra.values.gcp_project_id
  region          = data.tfe_outputs.gcp-infra.values.gcp_region
  network_name    = data.tfe_outputs.gcp-infra.values.vpc_name
  subnet_name     = data.tfe_outputs.gcp-infra.values.vpc_subnet
  subnet_id       = nonsensitive(data.tfe_outputs.gcp-infra.values.vpc_subnet_id)
  project_prefix  = data.tfe_outputs.gcp-infra.values.project_prefix
  service_account = data.tfe_outputs.gcp-infra.values.service_account
  app_ip          = data.tfe_outputs.f5-air.values.app_ip
}
