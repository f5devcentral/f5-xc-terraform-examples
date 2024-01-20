locals {
  project_prefix = data.tfe_outputs.infra.values.project_prefix
  build_suffix = data.tfe_outputs.infra.values.build_suffix
  #59origin_bigip = try(data.tfe_outputs.bigip.values.bigip_public_vip, "")
  #59origin_nginx = try(data.tfe_outputs.nap.values.external_name, data.tfe_outputs.nic.values.external_name, "")
  origin_bigip = try(data.tfe_outputs.bigip[0].values.bigip_public_vip, "")
  origin_nginx = try(data.tfe_outputs.nap[0].values.external_name, data.tfe_outputs.nic[0].values.external_name, "")
  origin_arcadia = try(data.tfe_outputs.azure-vm[0].values.vm_ip, data.tfe_outputs.gcp-vm[0].values.demo_private_ip, "")
  origin_boutique_ip = try(data.tfe_outputs.aws_eks_cluster[0].values.private_ips[0], "")
  origin_server = "${coalesce(local.origin_bigip, local.origin_nginx, local.origin_arcadia, local.origin_boutique_ip, var.serviceName)}"
  #59origin_port = try(data.tfe_outputs.nap.values.external_port, data.tfe_outputs.nic.values.external_port, "80")
  aws_ec2_subnet = try(data.tfe_outputs.aws_eks_cluster[0].values.subnets_of_ec2[0], "")
  aws_ec2_azs = try(data.tfe_outputs.aws_eks_cluster[0].values.availability_zones_ec2[0], "")
  origin_port = try(data.tfe_outputs.nap[0].values.external_port, data.tfe_outputs.nic[0].values.external_port, data.tfe_outputs.azure-vm[0].values.arcadia_port, data.tfe_outputs.aws_eks_cluster[0].values.boutique_port, "80")
  dns_origin_pool = local.origin_nginx != "" ? true : false 
  vpc_id              = try(data.tfe_outputs.infra.values.vpc_id, "")
  kubeconfig = try(data.tfe_outputs.aks-cluster[0].values.kube_config, "")
  azure_region        = try(data.tfe_outputs.infra.values.azure_region, "")
  resource_group_name = try(data.tfe_outputs.infra.values.resource_group_name, "")
  vnet_name           = try(data.tfe_outputs.infra.values.vnet_name, "")
  subnet_name         = try(data.tfe_outputs.infra.values.subnet_name, data.tfe_outputs.infra.values.vpc_subnet, "")
  subnet_id           = try(data.tfe_outputs.infra.values.subnet_id, "")
  gcp_region          = try(data.tfe_outputs.infra.values.gcp_region, "")
  vpc_name            = try(data.tfe_outputs.infra.values.vpc_name, "")
  host                = try(data.tfe_outputs.eks[0].values.cluster_endpoint, "")
  aws_region          = try(data.tfe_outputs.infra.values.aws_region, "")
  cluster_name        = try(data.tfe_outputs.eks[0].values.cluster_name, "")
}