# terraform {
#   cloud {
#     organization = "example-org-fa8f78"
#     workspaces {
#       name = "xcmcn-ce-aws-eks"
#     }
#   }
# }
# data "tfe_outputs" "root" {
#   organization = var.tf_cloud_organization
#   workspace = "xcmcn-ce-root"
# }
# data "tfe_outputs" "aws" {
#   organization = var.tf_cloud_organization
#   workspace = "xcmcn-ce-aws"
# }