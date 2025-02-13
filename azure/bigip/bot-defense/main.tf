provider "bigip" {
    address               = local.bigip_ip
    username              = "admin"
    password              = local.bigip_password
    port                  = "8443"
}