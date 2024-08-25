locals {
  project_prefix      = data.tfe_outputs.gcp-infra.values.project_prefix
  build_suffix        = data.tfe_outputs.gcp-infra.values.build_suffix
  gcp_project_id      = data.tfe_outputs.gcp-infra.values.gcp_project_id
  gcp_region          = data.tfe_outputs.gcp-infra.values.gcp_region
  gcp_vpc_name        = data.tfe_outputs.gcp-infra.values.vpc_name
  gcp_vpc_subnet      = data.tfe_outputs.gcp-infra.values.vpc_subnet
  azure_region        = data.tfe_outputs.azure-infra.values.azure_region
  azure_resource_group= data.tfe_outputs.azure-infra.values.resource_group_name
  azure_vnet_name     = data.tfe_outputs.azure-infra.values.vnet_name
  azure_subnet_name   = data.tfe_outputs.azure-infra.values.subnet_name
  aks_node_private_ip = [for node in data.kubernetes_nodes.aks.nodes : ([for addr in node.status[0].addresses : addr.address if addr.type == "InternalIP"])[0]][0]
  commonLabels        = {
    mcn_smg_label     = format("%s-label_value", local.project_prefix)
  }
  details_node_port   = 31002
  product_node_port   = 31849
  details_domain      = ["details"]
}
