module "azure_cloud_credentials" {
  count = ("" == var.azure_cloud_credentials_name) ? 1 : 0
  
  source  = "f5devcentral/azure-cloud-credentials/xc"
  version = "0.0.6"

  name                  = local.azure_site_name
  azure_subscription_id = coalesce(var.xc_azure_subscription_id, var.azure_subscription_id)
  azure_tenant_id       = coalesce(var.xc_azure_tenant_id, var.azure_tenant_id)
  azure_client_id       = coalesce(var.xc_azure_client_id, var.azure_client_id)
  azure_client_secret   = coalesce(var.xc_azure_client_secret, var.azure_client_secret)
  create_sa             = var.azure_create_sa
}