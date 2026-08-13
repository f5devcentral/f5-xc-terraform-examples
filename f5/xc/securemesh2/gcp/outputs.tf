output "instance_self_link" {
  description = "Self-link for the compute instance."
  value       = google_compute_instance.smv2_instance[*].self_link
}

output "instances_ephemeral_ips" {
  description = "Ephemeral external IPs of the first network interface for all instances"
  value = [
    for instance in google_compute_instance.smv2_instance : instance.network_interface[0].access_config[0].nat_ip
  ]
}

output "sli_private_ips" {
  description = "Private (internal) IP addresses of the SLI network interface (nic1) for all instances."
  value = [
    for instance in google_compute_instance.smv2_instance : instance.network_interface[1].network_ip
  ]
}
