locals {
  bigip_username = data.tfe_outputs.bigip.values.bigip_username
  bigip_password  = nonsensitive(data.tfe_outputs.bigip.values.bigip_password[0])
  bigip_ip        = data.tfe_outputs.bigip.values.bigip.mgmtPublicIP
  bigip_private   = data.tfe_outputs.bigip.values.bigip_private_addresses[0][2]
  app_ip          = data.tfe_outputs.aks-cluster.values.external_ip
}