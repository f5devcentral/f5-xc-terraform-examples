# temporary file which is needed for site cleanup
resource "volterra_site_state" "site" {
  count = var.eks_ce_site ? 1 : 0
  name  = var.site_name
  state = "DECOMMISSIONING"
  when  = "delete"
}

resource "volterra_registration_approval" "k8s-ce" {
  count = var.eks_ce_site ? 1 : 0
  depends_on      =  [volterra_site_state.site]
  cluster_name  = var.site_name
  cluster_size  = 1
  retry = 5
  wait_time = 60
  hostname = "vp-manager-0"
}
