data "google_compute_zones" "zones" {
  project = local.gcpProjectId
  region  = local.gcpRegion
  status  = "UP"
}