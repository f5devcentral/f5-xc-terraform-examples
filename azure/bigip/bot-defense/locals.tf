locals {
  bigip_public_ip = data.tfe_outputs.bigip.values.mgmtPublicIP[0]
  bigip_username  = data.tfe_outputs.bigip.values.bigip_username[0]
  bigip_password  = nonsensitive(data.tfe_outputs.bigip.values.bigip_password[0])
  bigip_private_ip  = data.tfe_outputs.bigip.values.bigip_private_addresses[0]["mgmt_private"]["private_ip"][0]
  port            = data.tfe_outputs.bigip.values.mgmtPort[0]
  app_ip          = data.tfe_outputs.aks-cluster.values.app_external_ip
}