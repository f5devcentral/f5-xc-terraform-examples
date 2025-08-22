module "azure_cloud_credentials" {
  count = ("" == var.azure_cloud_credentials_name) ? 1 : 0
  
  source  = "f5devcentral/azure-cloud-credentials/xc"
  version = "0.0.7"

  name                  = ("" != var.prefix) ? format("%s-%s", var.prefix, var.name) : var.name
  azure_subscription_id = try(coalesce(var.xc_azure_subscription_id, var.azure_subscription_id), null)
  azure_tenant_id       = try(coalesce(var.xc_azure_tenant_id, var.azure_tenant_id), null)
  azure_client_id       = try(coalesce(var.xc_azure_client_id, var.azure_client_id), null)
  azure_client_secret   = try(coalesce(var.xc_azure_client_secret, var.azure_client_secret), null)
  create_sa             = var.azure_create_sa
}