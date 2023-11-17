output "tenant_name" {
  value = data.volterra_namespace.this.tenant_name
  description = "XC Tenant Name"
}