resource "volterra_registration_approval" "k8s-ce" {
  cluster_name  = var.site_name
  cluster_size  = 1
  retry = 5
  wait_time = 60
  hostname = "vp-manager-0"
}
