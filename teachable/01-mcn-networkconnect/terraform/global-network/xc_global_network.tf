resource "volterra_virtual_network" "global_vn" {
  name           = format("%s-gn", local.workload_name)
  namespace      = "system"
  global_network = true
}