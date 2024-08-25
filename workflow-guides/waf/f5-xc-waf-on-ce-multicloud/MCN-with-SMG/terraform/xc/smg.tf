resource "volterra_known_label_key" "volterra_known_label_key" {
    key         = mcn_smg_label
    namespace   = "shared"
    description = "mcn smg key"
}


resource "volterra_known_label" "volterra_known_label" {
  key         = volterra_known_label_key.volterra_known_label_key.key
  value       = format("%s-label_value", local.project_prefix)
  namespace   = "shared"
  description = "mcn smg value"
  depends_on = [volterra_known_label_key.volterra_known_label_key]
}


# Create a virtual site that will identify services deployed in Azure, and GCP.
resource "volterra_virtual_site" "site" {
  depends_on = [volterra_known_label.volterra_known_label]
  name        = format("%s-vsite", local.project_prefix)
  namespace   = "shared"
  description = format("Virtual site for %s", local.project_prefix)
  site_type   = "CUSTOMER_EDGE"
  site_selector {
    expressions = [
      join(",", [for k, v in local.commonLabels : format("%s = %s", k, v)])
    ]
  }
}


# Create full site mesh group with a label selector that each CE Site will be labeled on creation
resource "volterra_site_mesh_group" "smg" {
  name      = format("%s-smg", local.project_prefix)
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