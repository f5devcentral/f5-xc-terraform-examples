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
resource "google_compute_network" "f5_network_prometheus" {
  name = "f5-network-prometheus"
}

# Define a firewall rule for incoming traffic (similar to security group rules)
resource "google_compute_firewall" "f5_firewall_prometheus" {
  name    = "f5-firewall-prometheus"
  network = google_compute_network.f5_network_prometheus.name

  allow {
    protocol = "tcp"
    ports    = ["22", "8888", "8080", "3000", "9090"]  # List of ports you want to allow
  }

  source_ranges = ["0.0.0.0/0"]  # Allow traffic from all sources
}

# Create a VM instance
resource "google_compute_instance" "f5_vm_prometheus" {
  name         = "f5-vm-prometheus"
  machine_type = "n1-standard-2"
  zone        = var.local_paths["zone"]

  # Attach the instance to the VPC network
  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2404-lts-amd64"  # Replace with your desired GCP image
      size  = 30                                    # Disk size in GB
      type  = "pd-balanced"                         # Equivalent to 'gp3' volume type
    }
  }

  network_interface {
    network = google_compute_network.f5_network_prometheus.name

    # Assign a public IP
    access_config {}
  }

  provisioner "file" {
  source      = "exporter_prometheus.py"
  destination = "/home/ubuntu/exporter_prometheus.py"
  }

  provisioner "file" {
  source      = var.local_paths["f5_api_cert_path"]
  destination = "/home/ubuntu/f5_api_certificate.p12"
  }

  provisioner "file" {
    source      = "prometheus.yml"
    destination = "/home/ubuntu/prometheus.yml"
  }

  provisioner "file" {
  source      = "grafana-prom.yaml"
  destination = "/tmp/prometheus-datasource.yml"
  }

  # Provisioner to execute commands on the remote EC2 instance
  provisioner "remote-exec" {
    inline = [
      "nohup python3 exporter_prometheus.py > python.log 2>&1 &",
      "sudo apt-get update -qq && sudo apt-get upgrade -y -qq",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "echo | sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt-get update -qq && sudo apt-get install docker-ce -y -qq",
      "sudo usermod -aG docker ubuntu",
      "export F5_XC_URL='https://${var.local_paths["f5_tenant"]}.console.ves.volterra.io/api/data/namespaces/${var.local_paths["f5_namespace"]}/graph/service'",
      "export P12_PATH='${var.local_paths["f5_api_cert_path"]}'",
      "export P12_PASSWORD='${var.local_paths["f5_api_cert_password"]}'",
      "export LB_NAME='${var.local_paths["f5_lb_name"]}'", # You can also parameterize this if needed
      "sudo apt install python3-flask -y -qq",
      "nohup python3 exporter_prometheus.py > python.log 2>&1 &",
      "sudo docker run -d --name=prometheus --network=host -v $(pwd)/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus:latest",
      "sudo mkdir -p /etc/grafana/provisioning/datasources",
      "sudo mv /tmp/prometheus-datasource.yml /etc/grafana/provisioning/datasources/prometheus.yaml",
      "sudo docker run -d --name=grafana -p 3000:3000 -v /etc/grafana/provisioning/datasources:/etc/grafana/provisioning/datasources grafana/grafana:latest > /dev/null 2>&1",
      "echo \"VM IP -> $(curl ifconfig.me -s)\"",
      "echo \"Prometheus -> $(curl ifconfig.me -s):9090\"",
      "echo \"Grafana -> $(curl ifconfig.me -s):3000\"",
      "echo \"Grafana default credentials -> admin/admin\"",
      "echo \"Metrics -> $(curl ifconfig.me -s):8888/metrics\""
    ]
  }

    connection {
      type        = "ssh"
      host        = self.network_interface[0].access_config[0].nat_ip  # Use public IP
      user        = "ubuntu"  # Default username for Ubuntu images in GCP
      private_key = file(var.local_paths["ssh_key_path"])  # Path to your private key
    }
  
  tags = ["f5-prometheus"]  # Assign network tags (useful for firewall rules and organization)
}