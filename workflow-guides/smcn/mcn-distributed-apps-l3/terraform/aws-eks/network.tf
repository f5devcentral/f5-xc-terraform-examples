

# Create Elastic IP
resource "aws_eip" "main" {
  tags = {
    Name          = format("%s-eip", local.name)
  }
}

resource "aws_subnet" "eks-internal" {
  count             = length(local.eks_az_names)
  vpc_id            = local.aws_vpc_id
  cidr_block        = element(local.eks_internal_cidrs, count.index)
  availability_zone = element(local.eks_az_names, count.index)
  map_public_ip_on_launch = true
  
  tags              = {
    Name = format("%s-eks-int-subnet-%s",local.name, count.index)
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

# resource "aws_subnet" "eks-external" {
#   count             = length(local.eks_az_names)
#   vpc_id            = local.aws_vpc_id
#   cidr_block        = element(local.eks_external_cidrs, count.index)
#   availability_zone = element(local.eks_az_names, count.index)
  
#   tags              = {
#     Name = format("%s-eks-ext-subnet-%s",local.name, count.index)
#     "kubernetes.io/cluster/${local.cluster_name}" = "shared"
#     "kubernetes.io/role/internal-elb"             = "1"
#   }
# }

resource "aws_route_table_association" "eks-subnet-association" {
  count = length(aws_subnet.eks-internal)
  subnet_id      = element(aws_subnet.eks-internal, count.index).id
  route_table_id = local.route_table_id
}
