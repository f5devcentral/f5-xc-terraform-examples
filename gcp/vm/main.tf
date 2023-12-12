provider "google" {
  region      = local.gcp_region
  project     = local.gcp_project_id
}

# virtual machine creation
resource "google_compute_instance" "demo_application" {
  name         = "${local.project_prefix}-instance-${local.build_suffix}"
  machine_type = "e2-medium"
  zone         = "${local.gcp_region}-a"
  tags         = ["docker-node"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-focal-v20230918"
    }
  }

  network_interface {
    network = local.vpc_name
	subnetwork   = local.subnet_name
    access_config {
      # Ephemeral
    }
  }

  metadata = {
    ssh-keys = "root:${file("id_rsa_new.pub")}"
  }

  provisioner "remote-exec" {
  connection {
    type        = "ssh"
    host        = google_compute_instance.demo_application.network_interface.0.access_config.0.nat_ip
    user        = "root"
    private_key = "${file("id_rsa_new")}"
    agent       = false
  }

  inline = [
    "sudo apt update -y",
    "sudo apt install docker.io -y",
    "sudo docker run -d -p 80:3000 bkimminich/juice-shop"
  ]
  }

  service_account {
    scopes = ["https://www.googleapis.com/auth/compute.readonly"]
  }
}
