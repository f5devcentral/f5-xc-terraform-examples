output "project_prefix" {
  value = var.project_prefix
}

output "gcp_project_id" {
  value = var.gcp_project_id
}

output "gcp_region" {
  value = var.gcp_region
}

output "build_suffix" {
  value = random_id.build_suffix.hex
}

output "vpc_name" {
	value = google_compute_network.vpc_network.name
}

output "vpc_subnet" {
	value = google_compute_subnetwork.public_subnetwork.name
}

output "nap" {
  value = var.nap
}
output "nic" {
  value = var.nic
}
output "bigip" {
  value = var.bigip
}
output "bigip-cis" {
  value = var.bigip-cis
}
output "aks-cluster" {
  value = var.aks-cluster
}
output "azure-vm" {
  value = var.azure-vm
}
