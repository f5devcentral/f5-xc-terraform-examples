data "tfe_outputs" "azure-infra" {
  organization = var.tf_cloud_organization
  workspace = "azure-infra"
}
data "local_file" "out" {
        filename = "./output.txt"
}