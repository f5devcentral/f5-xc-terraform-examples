provider "bigip" {
    address               = local.bigip_public_ip
    username              = local.bigip_username
    password              = local.bigip_password
    port                  = "8443"
}