resource "google_storage_bucket" "gcs_elk_bucket" {
  name                        = var.bucket_name 
  location                    = var.storage_location                       
  storage_class               = "STANDARD"                  
  force_destroy               = true                        
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age                   = 30
      num_newer_versions    = 3
    }
  }
}