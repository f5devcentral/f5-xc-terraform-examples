# temporary file which is needed for site cleanup
resource "volterra_site_state" "site" {
  count = var.eks_ce_site ? 1 : 0
  name  = var.site_name
  state = "DECOMMISSIONING"
  when  = "delete"
  retry           = 5
  wait_time       = 60
}

resource "volterra_site_state" "site2" {
  count = var.gke_ce_site ? 1 : 0
  name  = var.gke_site_name
  state = "DECOMMISSIONING"
  when  = "delete"
  retry           = 5
  wait_time       = 60
}


resource "volterra_registration_approval" "k8s-ce" {
  count           = var.eks_ce_site ? 1 : 0
  depends_on      = [volterra_site_state.site]
  cluster_name    = var.site_name
  cluster_size    = 1
  retry           = 5
  wait_time       = 60
  hostname        = "vp-manager-0"
  provisioner "local-exec" {
  command     = "sleep 30"
  }
}

resource "volterra_registration_approval" "gcp-ce" {
  count           = var.gke_ce_site ? 1 : 0
  depends_on      = [volterra_site_state.site]
  cluster_name    = var.gke_site_name
  cluster_size    = 1
  retry           = 5
  wait_time       = 60
  hostname        = "vp-manager-0"
  provisioner "local-exec" {
  command     = "sleep 30"
  }
}