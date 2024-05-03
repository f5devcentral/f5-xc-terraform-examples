# Create a virtual site that will identify services deployed in AWS, Azure, and GCP.
resource "volterra_virtual_site" "site" {
  name        = format("%s-vsite", local.name)
  namespace   = "shared"
  description = format("Virtual site for %s", local.name)
  labels      = local.commonLabels
  site_type   = "CUSTOMER_EDGE"
  site_selector {
    expressions = [
      join(",", [for k, v in local.commonLabels : format("%s = %s", k, v)])
    ]
  }
}

# Create global network to connect the sites using a site mesh group
resource "volterra_virtual_network" "global_vn" {
  name                      = format("%s-gn", local.name)
  namespace                 = "system"
  global_network            = true
  site_local_network        = true
  site_local_inside_network = false
}

# Create full site mesh group with a label selector that each CE Site will be labeled on creation
resource "volterra_site_mesh_group" "smg" {
  name      = format("%s-smg", local.name)
  namespace = "system"

  virtual_site {
    name      = volterra_virtual_site.site.name
    namespace = "shared"
  }
  full_mesh {
    control_and_data_plane_mesh = true
  }

  depends_on = [volterra_virtual_site.site]
}
