
variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  description = "Deployment Region"
}

variable bucket_name {
    type = string
    description = "GCS Bucket Name"
}

variable storage_location {
    type = string
    description = "GCS Bucket Location"
}
