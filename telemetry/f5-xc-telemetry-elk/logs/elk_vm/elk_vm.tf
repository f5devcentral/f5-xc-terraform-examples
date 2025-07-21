resource "google_compute_network" "vpc" {
  name                    = var.vpc
  auto_create_subnetworks = true
}

resource "google_compute_instance" "elk-vm" {
  name         = var.vm
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image    = "ubuntu-os-cloud/ubuntu-2004-focal-v20230918"
    }
  }

  network_interface {
    network = google_compute_network.vpc.id
    access_config {} # Gives public IP
  }

  provisioner "file" {
    source      = "./docker-compose.yml"   # Path to local file
    destination = "/home/ubuntu/docker-compose.yml"         # Destination on the VM
  }

  provisioner "file" {
    source      = "./logstash.conf"   # Path to local file
    destination = "/home/ubuntu/logstash.conf"         # Destination on the VM
  } 

  metadata = {
    ssh-keys = "ubuntu:${file("./id_rsa.pub")}"
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("./id_rsa")      # Path to the private SSH key
    host     = self.network_interface[0].access_config[0].nat_ip
  }

  metadata_startup_script = <<-SCRIPT
    #!/bin/bash
    # Update and install Docker
    sudo apt-get update
    sudo apt-get install -y docker.io
    echo "docker installed" >> /home/ubuntu/script.log

    curl -L "https://github.com/docker/compose/releases/download/v2.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    
    echo "docker-compose installed" >> /home/ubuntu/script2.log

    sudo git clone https://github.com/deviantony/docker-elk.git
    sleep 60
    sudo mv /home/ubuntu/docker-compose.yml /docker-elk/docker-compose.yml
    sudo mv /home/ubuntu/logstash.conf /docker-elk/logstash/pipeline/logstash.conf
    cd docker-elk

    sudo docker-compose up setup
    sleep 120
    sudo docker-compose up -d
    sleep 120

  SCRIPT

  tags = ["elk"]

  service_account {
    scopes = ["cloud-platform"]
  }

}

resource "google_compute_firewall" "elk-fw" {
  name    = var.fw
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["5601", "9200", "5000", "22", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["elk"]
}

terraform {
  backend "gcs" {
  }
}