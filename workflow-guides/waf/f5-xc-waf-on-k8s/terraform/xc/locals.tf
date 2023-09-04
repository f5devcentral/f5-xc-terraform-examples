locals {
  project_prefix = data.tfe_outputs.infra.values.project_prefix
  build_suffix = data.tfe_outputs.infra.values.build_suffix
  k8s_origin_pool = true

}