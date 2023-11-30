resource "volterra_registration_approval" "k8s-ce" {
  count = var.eks_ce_site ? 1 : 0
  cluster_name  = var.site_name
  cluster_size  = 1
  retry = 5
  wait_time = 60
  hostname = "vp-manager-0"
}
