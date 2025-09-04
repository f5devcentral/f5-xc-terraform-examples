variable "local_paths" {
  description = "Local paths and identifiers for GCP and F5 setup"
  type        = map(string)
}

provider "google" {
  project     = var.local_paths["project_id"]                   # GCP project ID
  credentials = file(var.local_paths["gcp_credentials_file"])   # Path to GCP credentials file
  region      = var.local_paths["region"]                       # GCP region
  zone        = var.local_paths["zone"]                         # Select an appropriate zone in your region
}

# Create a VPC network (required for firewall rule and instance)
resource "google_compute_network" "f5_network_loki" {
  name = "f5-network-loki"
}

# Define a firewall rule for incoming traffic (similar to security group rules)
resource "google_compute_firewall" "f5_firewall_loki" {
  name    = "f5-firewall-loki"
  network = google_compute_network.f5_network_loki.name

  allow {
    protocol = "tcp"
    ports    = ["22", "3000", "3001", "3100", "5000"]  # List of ports you want to allow
  }

  source_ranges = ["0.0.0.0/0"]  # Allow traffic from all sources
}

# Create a VM instance
resource "google_compute_instance" "f5_vm_loki" {
  name         = "f5-vm-loki"
  machine_type = "n1-standard-2"
  zone         = var.local_paths["zone"]

  # Attach the instance to the VPC network
  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2404-lts-amd64"  # Replace with your desired GCP image
      size  = 30                                    # Disk size in GB
      type  = "pd-balanced"                         # Equivalent to 'gp3' volume type
    }
  }

  network_interface {
    network = google_compute_network.f5_network_loki.name

    # Assign a public IP
    access_config {}
  }

  provisioner "file" {
    source      = "webhook.py"
    destination = "/home/ubuntu/webhook.py"
  }

  provisioner "file" {
  source      = "grafana-loki.yaml"
  destination = "/tmp/loki-datasource.yml"
  }

  # Provisioner to execute commands on the remote EC2 instance
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -qq && sudo apt-get upgrade -y -qq",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "echo | sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt-get update -qq && sudo apt-get install docker-ce -y -qq",
      "sudo usermod -aG docker ubuntu",
      "sudo docker run -d -p 3001:3000 bkimminich/juice-shop > /dev/null 2>&1",
      "sudo docker run -d --name=loki -p 3100:3100 grafana/loki:latest > /dev/null 2>&1",
      "sudo mkdir -p /etc/grafana/provisioning/datasources",
      "sudo mv /tmp/loki-datasource.yml /etc/grafana/provisioning/datasources/loki.yaml",
      "sudo docker run -d --name=grafana -p 3000:3000 -v /etc/grafana/provisioning/datasources:/etc/grafana/provisioning/datasources grafana/grafana:latest > /dev/null 2>&1",
      "sudo apt install python3-flask -y -qq",
      "nohup python3 webhook.py > python.log 2>&1 &",
      "echo $(curl ifconfig.me -s):5000/glr-webhook",
      "echo \"Grafana -> $(curl ifconfig.me -s):3000\"",
      "echo \"Loki -> $(curl ifconfig.me -s):3100\""
    ]
  }

    connection {
      type        = "ssh"
      host        = self.network_interface[0].access_config[0].nat_ip  # Use public IP
      user        = "ubuntu"  # Default username for Ubuntu images in GCP
      private_key = file(var.local_paths["ssh_key_path"])  # Path to your private key
    }

  tags = ["f5-loki"]  # Assign network tags (useful for firewall rules and organization)
}