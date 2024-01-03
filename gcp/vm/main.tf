provider "google" {
  region      = local.gcp_region
  project     = local.gcp_project_id
}

# SSH Key
variable "ssh_key" {
  type        = string
  description = "public key used for authentication in ssh-rsa format"
}

# virtual machine with juiceshop deployed as docker container
resource "google_compute_instance" "demo_application" {
  name         = "${local.project_prefix}-application-${local.build_suffix}"
  machine_type = "e2-medium"
  zone         = "${local.gcp_region}-a"
  tags         = ["docker-node"]

  boot_disk {
    initialize_params {
      image    = "ubuntu-os-cloud/ubuntu-2004-focal-v20230918"
    }
  }

  network_interface {
    network      = local.vpc_name
	subnetwork   = local.subnet_name
    access_config {
      # Ephemeral
    }
  }

  metadata = {
    ssh-keys = "root:var.ssh_key"
  }

  metadata_startup_script = <<-EOF
  #! /bin/bash
  sudo apt update -y
  sudo apt install docker.io -y
  sudo docker run -d -p 80:3000 bkimminich/juice-shop
  EOF

  service_account {
    scopes      = ["https://www.googleapis.com/auth/compute.readonly"]
  }
}
