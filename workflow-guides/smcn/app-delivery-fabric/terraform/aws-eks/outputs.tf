output "cluster_id" {
  description = "EKS cluster ID"
  value       = aws_eks_cluster.eks-tf.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.eks-tf.endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = nonsensitive(aws_eks_cluster.eks-tf.name)
}

output "kubeconfig_certificate_authority_data" {
  value = aws_eks_cluster.eks-tf.certificate_authority[0].data
#  sensitive = true
}

# output "slo_subnet" {
#   description = "VPC Subnet for EKS Cluster nodes"
#   value       = concat([for e in data.aws_subnet.slo_subnet: e.id])
# }
