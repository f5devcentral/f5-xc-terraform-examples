output "demo_ip" {
  value = google_compute_instance.demo_application.network_interface.0.access_config.0.nat_ip
}
