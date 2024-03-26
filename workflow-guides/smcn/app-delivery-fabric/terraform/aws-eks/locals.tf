locals {
  name               = ("" != var.prefix) ? format("%s-%s", var.prefix, var.name) : var.name
  awsRegion          = var.aws_region
  aws_vpc_id         = var.aws_vpc_id 
  aws_vpc_cidr       = var.aws_vpc_cidr 
  eks_internal_cidrs = var.eks_internal_cidrs
  eks_az_names       = length(var.eks_az_names) > 0 ? var.eks_az_names : slice(data.aws_availability_zones.available.names, 0, length(local.eks_internal_cidrs))
  cluster_name       = format("%s-eks-cluster", local.name)
  route_table_id     = var.route_table_id

  xc_cidr            = var.xc_cidr

  eks_desired_sise = 1
  eks_max_size     = 1
  eks_min_size     = 1
}
