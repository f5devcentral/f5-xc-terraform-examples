module bigip {
  count            = 1
  source           = "F5Networks/bigip-module/gcp"
  prefix           = local.project_prefix
  project_id       = local.project_id
  zone             = "${local.region}-a"
  image            = var.image
  service_account  = local.service_account
  f5_password      = var.bigip_password
  vm_name          = "${local.project_prefix}-bigip"
  network_tags     = ["bigip"]
  f5_ssh_publickey = "./id_rsa.pub"
  mgmt_subnet_ids  = [{ "subnet_id" = local.subnet_id, "public_ip" = true, "private_ip_primary" = "" }]
}

# firewall rules
resource "google_compute_firewall" "allow-ports" {
  name          = "${local.project_prefix}-allow"
  network       = local.network_name
  allow {
    protocol    = "tcp"
    ports       = ["22", "80", "443", "8443"]
  }
  allow {
    protocol    = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bigip"]
}
