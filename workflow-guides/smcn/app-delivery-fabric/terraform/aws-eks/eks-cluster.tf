
# Create EKS cluster and node groups
resource "aws_eks_cluster" "eks-tf" {
 name     = local.cluster_name
 role_arn = aws_iam_role.eks-iam-role.arn

  vpc_config {
    security_group_ids      = flatten([aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id])
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
    subnet_ids              = [for e in aws_subnet.eks-internal: e.id]
  }

  depends_on = [
    aws_iam_role.eks-iam-role,
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly-EKS,
    aws_iam_role_policy_attachment.eks_cluster_ingress_loadbalancer_creation,
    aws_iam_role_policy_attachment.eks_iam_ingress_loadbalancer_creation,
    aws_subnet.eks-internal
  ]
}

resource "aws_eks_node_group" "private-node-group-1-tf" {
  cluster_name    = aws_eks_cluster.eks-tf.name
  node_group_name = format("%s-private-ng-1", local.name)
  node_role_arn   = aws_iam_role.workernodes.arn
  subnet_ids      =  [for i in aws_subnet.eks-internal: i.id]
  instance_types  = ["t3.medium"]
  capacity_type   = "SPOT"
 
  scaling_config {
   desired_size = local.eks_desired_sise
   max_size     = local.eks_max_size
   min_size     = local.eks_min_size
  }

  tags = {
    Name = format("%s-private-ng-1", local.name)
  }
 
  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
   aws_eks_cluster.eks-tf
  ]
}

resource "aws_eks_addon" "cluster-addons" {
  for_each                    = { for addon in var.eks_addons : addon.name => addon }
  cluster_name                = aws_eks_cluster.eks-tf.id
  addon_name                  = each.value.name
  resolve_conflicts_on_create = "OVERWRITE"
}
