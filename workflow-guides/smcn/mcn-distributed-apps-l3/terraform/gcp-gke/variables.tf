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

variable "network_name" {
  type        = string
  description = "Name of the network"
  default     = ""
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet"
  default     = ""
}

variable "cluster_cidr" {
  type        = string
  description = "CIDR for the cluster"
  default     = ""
}

variable "services_cidr" {
  type        = string
  description = "CIDR for the services"
  default     = ""
}

#---------------------------------------------
# Google Cloud Platform (GCP) Variables
#---------------------------------------------

# GCP Specific vars - if these are not empty/null, GCP resources will be created
variable "gcp_region" {
  type        = string
  default     = null
  description = "region where GCP resources will be deployed"
}

variable "gcp_project_id" {
  type        = string
  default     = null
  description = "gcp project id"
}
