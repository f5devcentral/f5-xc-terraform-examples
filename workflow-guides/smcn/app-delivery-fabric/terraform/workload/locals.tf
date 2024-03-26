locals {
  name       = ("" != var.prefix) ? format("%s-%s", var.prefix, var.name) : var.name
  namespace  = ("" != var.namespace) ? var.namespace : local.name
  eks_namespace = (local.create_eks_namespace) ? element(kubernetes_namespace.eks_namespace, 0).metadata.0.name : local.namespace
  aks_namespace = (local.create_aks_namespace) ? element(kubernetes_namespace.aks_namespace, 0).metadata.0.name : local.namespace
  xc_namespace  = (local.create_xc_namespace) ? element(volterra_namespace.xc, 0).name : local.namespace

  create_aks_namespace = ("true" == var.create_aks_namespace) ? true : false
  create_eks_namespace = ("true" == var.create_eks_namespace) ? true : false
  create_xc_namespace  = ("true" == var.create_xc_namespace) ? true : false

  app_domain     = var.app_domain
  details_domain = format("details.%s", local.app_domain)

  aks_node_private_ip = ("" != var.aks_node_private_ip) ? var.aks_node_private_ip : [for node in data.kubernetes_nodes.aks.nodes : ([for addr in node.status[0].addresses : addr.address if addr.type == "InternalIP"])[0]][0]
  eks_node_private_ip = ("" != var.eks_node_private_ip) ? var.eks_node_private_ip : [for node in data.kubernetes_nodes.eks.nodes : ([for addr in node.status[0].addresses : addr.address if addr.type == "InternalIP"])[0]][0]

  xc_security_group_id = var.xc_security_group_id

  #------------------------------------------------
  # Bookinfo
  #------------------------------------------------

  product_node_port = 31001
  details_node_port = 31002

  #------------------------------------------------
  # AWS
  #------------------------------------------------

  aws_site_name              = var.aws_site_name
  aws_xc_inside_subnet_id    = var.aws_xc_inside_subnet_id
  aws_xc_outside_subnet_id   = var.aws_xc_outside_subnet_id
  aws_vpc_id                 = var.aws_vpc_id
  aws_xc_node_inside_ip      = ("" != var.aws_xc_node_inside_ip) ? var.aws_xc_node_inside_ip : data.aws_network_interface.xc_private_nic[0].private_ips[0]
  aws_xc_node_outside_ip     = ("" != var.aws_xc_node_outside_ip) ? var.aws_xc_node_outside_ip : data.aws_network_interface.xc_public_nic[0].association[0].public_ip
  eks_cluster_name           = ("" != var.eks_cluster_name) ? var.eks_cluster_name : format("%s-eks-cluster", local.name)
  eks_cluster_host           = var.eks_cluster_host
  eks_cluster_ca_certificate = var.eks_cluster_ca_certificate

  #------------------------------------------------
  # Azure
  #------------------------------------------------

  azure_site_name           = var.azure_site_name
  azure_resource_group_name = ("" != var.azure_resource_group_name) ? var.azure_resource_group_name : local.name
  aks_cluster_name          = ("" != var.aks_cluster_name) ? var.aks_cluster_name : format("%s-aks-cluster", local.name)
}