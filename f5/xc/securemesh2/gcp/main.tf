provider "google" {
  project = var.project_id
}

resource "random_id" "rand_id" {
  byte_length = 3
}

resource "google_compute_instance" "smv2_instance" {
  count = var.instance_count
  name = "${var.goog_cm_deployment_name}-${random_id.rand_id.hex}-${count.index + 1}"
  machine_type = var.machine_type
  zone = var.zones[count.index]
  allow_stopping_for_update = true

  tags = var.network_tags

  boot_disk {
    device_name = "autogen-vm-tmpl-boot-disk"

    initialize_params {
      size = var.boot_disk_size
      type = "pd-standard"
      image = "${var.source_image_path}/${var.source_image_name}"
    }
  }

  can_ip_forward = true

  metadata = {
    VmDnsSetting = "ZonalPreferred"
    ssh-keys     = join("\n", [for item in var.ssh_keys : "user:${item}"])
    user-data    = "#cloud-config\nwrite_files:\n  - path: /etc/vpm/user_data\n    permissions: 644\n    owner: root\n    content: |\n      token: ${var.token}"
  }

  dynamic "network_interface" {
    for_each = var.subnets

    content {
      network    = network_interface.value.network
      subnetwork = network_interface.value.name

      # Add ephemeral IP only for the SLO subnet
      dynamic "access_config" {
        for_each = network_interface.key == 0 ? [1] : []

        content {}
      }
    }
  }

  service_account {
    email = "default"
    scopes = compact([
      "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol"
    ])
  }
  
  lifecycle {
    ignore_changes = [
      machine_type,
      min_cpu_platform,
      service_account,
      enable_display,
      shielded_instance_config,
      scheduling[0].node_affinities,
      scheduling[0].max_run_duration,
      network_interface,
    ]
  }
}
