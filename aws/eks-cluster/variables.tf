#Project Globals
variable "admin_src_addr" {
  type        = string
  description = "Allowed Admin source IP prefix"
  default     = "0.0.0.0/0"
}
#TF Cloud
variable "tf_cloud_organization" {
  type = string
  description = "TF cloud org (Value set in TF cloud)"
}
#AWS
variable "eks_addons" {
  type = list(object({
    name    = string
    version = string
  }))
  default = [
    {
      name    = "kube-proxy"
      version = "v1.25.6-eksbuild.1"
    },
    {
      name    = "vpc-cni"
      version = "v1.12.2-eksbuild.1"
    },
    {
      name    = "coredns"
      version = "v1.8.7-eksbuild.3"
    },
    {
      name    = "aws-ebs-csi-driver"
      version = "v1.13.0-eksbuild.3"
    }
  ]
}
variable "ssh_key" {
  type        = string
  description = "Unneeded for EKS, only present for warning handling with TF cloud variable set"
}

variable "skip_ha_az_node_group" {
  type        = bool
  description = "Whether to create 2nd Node Group or not, True implies not to create 2nd Node Group"
  default     = false
}

variable "desired_size" {
  type        = number
  description = "Desired size of the nodes in Node Group of EKS Cluster"
  default     = 2
}

variable "max_size" {
  type        = number
  description = "Maximum size of the nodes in Node Group of EKS Cluster"
  default     = 3
}

variable "min_size" {
  type        = number
  description = "Maximum size of the nodes in Node Group of EKS Cluster"
  default     = 1
}

variable "skip_private_subnet_creation" {
 type         = bool
 description  = "This creates in Nodes for EKS Cluster in Public Subnet instead of Private Subnet"
 default      = false
}

variable "allow_all_ingress_traffic_to_cluster" {
 type         = bool
 description  = "Acception all Traffic to the instance created by EKS Cluster Nodes"
 default      = false
}

variable "aws_access_key" {
  description = "AWS Access Key ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "aws_secret_key" {
  description = "AWS Secret Key ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "aws_waf_ce" {
  description = "Infra"
  type        = string
  default     = ""
}








