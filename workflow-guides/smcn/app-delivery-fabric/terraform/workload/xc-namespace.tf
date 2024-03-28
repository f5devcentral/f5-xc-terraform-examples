resource "volterra_namespace" "xc" {
  count = (local.create_xc_namespace) ? 1 : 0

  name = local.namespace
}