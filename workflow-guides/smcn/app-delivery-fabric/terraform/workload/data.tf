#------------------------------------------------
# AWS section
#------------------------------------------------

data "aws_eks_cluster" "eks" {
  name = ("" != local.eks_cluster_name) ? local.eks_cluster_name : format("%s-eks-cluster", local.name)
}

data "aws_eks_cluster_auth" "eks" {
  name = ("" != local.eks_cluster_name) ? local.eks_cluster_name : format("%s-eks-cluster", local.name)
}

data "kubernetes_nodes" "eks" {
  provider = kubernetes.eks
}

data "aws_instance" "xc_node" {
  count = ("" == var.aws_xc_node_inside_ip) ? 1 : 0

  filter {
    name   = "tag:ves-io-site-name"
    values = [local.aws_site_name]
  }

  filter {
    name   = "tag:Name"
    values = ["master-0"]
  }

  filter {
    name   = "vpc-id"
    values = [local.aws_vpc_id]
  }
}

data "aws_network_interface" "xc_private_nic" {
  count = ("" == var.aws_xc_node_inside_ip) ? 1 : 0

  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.xc_node[0].id]
  }

  filter {
    name   = "subnet-id"
    values = [local.aws_xc_inside_subnet_id]
  }
}

data "aws_network_interface" "xc_public_nic" {
  count = ("" == var.aws_xc_node_outside_ip) ? 1 : 0

  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.xc_node[0].id]
  }

  filter {
    name   = "subnet-id"
    values = [local.aws_xc_outside_subnet_id]
  }
}

#------------------------------------------------
# Azure section
#------------------------------------------------

data "azurerm_kubernetes_cluster" "aks" {
  name                =  ("" != local.aks_cluster_name) ? local.aks_cluster_name : format("%s-aks-cluster", local.name)
  resource_group_name = local.azure_resource_group_name
}

data "kubernetes_nodes" "aks" {
  provider = kubernetes.aks
}
