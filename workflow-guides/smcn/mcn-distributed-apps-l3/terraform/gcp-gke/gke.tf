
module "container_nodes_sa" {
  source          = "terraform-google-modules/service-accounts/google"
  version         = ">= 3.0"
  project_id      = local.project_id
  names           = [nonsensitive(format("%s-sa", local.name))]
  description     = nonsensitive(format("GKE cluster nodes service account (%s)", local.name))
  project_roles   = [
    "${local.project_id}=>roles/logging.logWriter",
    "${local.project_id}=>roles/monitoring.metricWriter",
    "${local.project_id}=>roles/monitoring.viewer",
    "${local.project_id}=>roles/compute.osLogin",
  ]
  generate_keys = false
}

# GKE cluster
resource "google_container_cluster" "primary" {
  name     = format("%s-gke-cluster", local.name)
  location = local.region

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  networking_mode          = "VPC_NATIVE"
  deletion_protection      = false
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = local.cluster_cird
    services_ipv4_cidr_block = local.services_cird
  }

  network    = local.network_name
  subnetwork = local.subnet_name
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  location   = local.region
  cluster    = google_container_cluster.primary.name
  node_count = local.gke_num_nodes

  /*
  network_config {
      enable_private_nodes = true
  }
  */

  node_config {
    service_account = module.container_nodes_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = local.project_id
    }

    # preemptible  = true
    machine_type = local.gke_machine_type
    tags         = ["gke-node", "${local.name}"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  depends_on = [ module.container_nodes_sa ]
}


# # Kubernetes provider
# # The Terraform Kubernetes Provider configuration below is used as a learning reference only. 
# # It references the variables and resources provisioned in this file. 
# # We recommend you put this in another file -- so you can have a more modular configuration.
# # https://learn.hashicorp.com/terraform/kubernetes/provision-gke-cluster#optional-configure-terraform-kubernetes-provider
# # To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/tutorials/terraform/kubernetes-provider.

# provider "kubernetes" {
#   load_config_file = "false"

#   host     = google_container_cluster.primary.endpoint
#   username = var.gke_username
#   password = var.gke_password

#   client_certificate     = google_container_cluster.primary.master_auth.0.client_certificate
#   client_key             = google_container_cluster.primary.master_auth.0.client_key
#   cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
# }
