variable "project_id" {
  type        = string
  description = "GCS Project ID"
}

variable "region" {
  type        = string
  description = "Deployment Region"
}

variable zone { 
    type = string
    description = "Deployment Zone"
}

variable fw { 
    type = string
    description = "Firewall name"
}

variable vm { 
    type = string
    description = "VM name"
}

variable vpc { 
    type = string
    description = "VPC name"
}