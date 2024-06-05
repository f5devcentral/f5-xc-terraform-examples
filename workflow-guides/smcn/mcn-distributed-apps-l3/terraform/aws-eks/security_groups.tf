
#Custer SG
resource "aws_security_group" "eks_cluster" {
  name        = format("%s-eks-cluster-sg", local.name)
  description = "Cluster communication with worker nodes"
  vpc_id      = local.aws_vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.aws_vpc_cidr]
  }

  tags = {
    Name = format("%s-eks-cluster-sg", local.name)
  }
}
#Cluster SG rules 
#Moved to aws_security_group.eks_cluster ingress argument above - dpotter 10/13/2023
/*
resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 443
  type                     = "ingress"
}
*/
resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "egress"
}

#Nodes SG
resource "aws_security_group" "eks_nodes" {
  name        = format("%s-eks-node-sg", local.name)
  description = "Security group for all nodes in the cluster"
  vpc_id      = local.aws_vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.aws_vpc_cidr]
  }

  tags = {
    Name = format("%s-eks-node-sg", local.name)
    "kubernetes.io/cluster/aws_eks_cluster.eks-tf.name" = "owned"
  }
}
#Nodes SG rules 
resource "aws_security_group_rule" "eks_nodes" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "ingress"
}
resource "aws_security_group_rule" "eks_nodes_inbound" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_cluster.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_vpc_security_group_ingress_rule" "eks-managed-ingress-80" {
  description       = "Allow internal and remote network traffic to the workloads"
  security_group_id = aws_eks_cluster.eks-tf.vpc_config[0].cluster_security_group_id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80

  depends_on  = [ aws_eks_cluster.eks-tf ]
}

resource "aws_vpc_security_group_ingress_rule" "eks-managed-ingress-443" {
  description       = "Allow internal and remote network traffic to the workloads"
  security_group_id = aws_eks_cluster.eks-tf.vpc_config[0].cluster_security_group_id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443

  depends_on        = [ aws_eks_cluster.eks-tf ]
}