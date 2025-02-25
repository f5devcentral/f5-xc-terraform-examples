locals {
  bigip_password  = nonsensitive(data.tfe_outputs.bigip.values.bigip_password[0])
  app_ip          = data.tfe_outputs.f5-air.values.app_ip
  bigip_ip        = data.tfe_outputs.bigip.values.bigip_public_addresses[0][0][0]
  bigip_private   = data.tfe_outputs.bigip.values.bigip_private_addresses[0][0]
}
