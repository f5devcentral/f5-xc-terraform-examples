provider "google" {
  project     = var.gcp_project_id
  region      = var.gcp_region
}

# Create a random id
resource "random_id" "build_suffix" {
  byte_length = 2
}


# VPC creation
resource "google_compute_network" "vpc_network" {
	name = "${var.project_prefix}-vpc-${random_id.build_suffix.hex}"
	auto_create_subnetworks = false
}

# Creating subnetwork
resource "google_compute_subnetwork" "public_subnetwork" {
	name = "${var.project_prefix}-subnet-${random_id.build_suffix.hex}"
	ip_cidr_range = var.cidr
	region = var.gcp_region
	network = google_compute_network.vpc_network.name
}

# firewall rules
resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.id
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}
