locals {
  project_prefix = var.project_prefix
  build_suffix   = random_id.build_suffix.hex
  #api_p12_file   = var.api_p12_file
}
