output "elk_vm_ip" {
  value = google_compute_instance.elk-vm.network_interface[0].access_config[0].nat_ip
}
