locals {
  bigip_public_ip = data.tfe_outputs.bigip.values.mgmtPublicIP[0]
  bigip_username  = data.tfe_outputs.bigip.values.bigip_username[0]
  bigip_password  = nonsensitive(data.tfe_outputs.bigip.values.bigip_password[0])
  bigip_private   = data.tfe_outputs.bigip.values.bigip_private_addresses[2][0][0]
  port            = data.tfe_outputs.bigip.values.mgmtPort[0]
  app_ip          = data.tfe_outputs.aks-cluster.values.external_ip
}