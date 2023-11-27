output "name" {
  value       = ("" == var.aws_cloud_credentials_name) ? module.aws_cloud_credentials[0].name : var.aws_cloud_credentials_name
  description = "Created XC Cloud Credentials name"
}

output "namespace" {
  value       = ("" == var.aws_cloud_credentials_name) ? module.aws_cloud_credentials[0].namespace : "system"
  description = "The namespace in which the XC Cloud Credentials is created"
}

output "id" {
  value       = ("" == var.aws_cloud_credentials_name) ? module.aws_cloud_credentials[0].id : null
  description = "ID of the created XC Cloud Credentials"
}