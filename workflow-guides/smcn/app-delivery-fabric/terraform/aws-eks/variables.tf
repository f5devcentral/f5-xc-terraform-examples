variable "name" {
  type        = string
  description = "Workload name"
  default     = ""
}

variable "prefix" {
  type        = string
  description = "Prefix for resource names"
  default     = ""
}

variable "aws_vpc_id" {
  type        = string
  description = "AWS VPC ID"
  default     = ""
}

variable "aws_vpc_cidr" {
  type        = string
  description = "AWS VPC CIDR"
  default     = ""
}

variable "eks_addons" {
  type = list(object({
    name    = string
    version = string
  }))
  default = [
    {
      name    = "kube-proxy"
      version = "v1.29.1-eksbuild.2"
    },
    {
      name    = "vpc-cni"
      version = "v1.17.1-eksbuild.1"
    },
    {
      name    = "coredns"
      version = "v1.11.1-eksbuild.6"
    },
    {
      name    = "aws-ebs-csi-driver"
      version = "v1.28.0-eksbuild.1"
    }
  ]
}

variable "eks_az_names" {
  type = list(string)
  default = []
}

variable "route_table_id" {
  type        = string
  description = "Route table ID"
  default     = ""
}

variable "eks_internal_cidrs" {
  type = list(string)
  default = []
}

variable "xc_cidr" {
  type        = string
  description = "CIDR for XC network"
  default     = ""
}

#------------------------------------------------
# AWS Provider Configuration
#------------------------------------------------

variable "aws_access_key" {
  type        = string
  default     = null
  description = "AWS access key"
}

variable "aws_secret_key" {
  type        = string
  sensitive   = true
  description = "AWS secret key"
  default     = null
}

variable "aws_token" {
  type        = string
  default     = null
  description = "AWS Session token"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}
