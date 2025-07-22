data "terraform_remote_state" "elk" {
  backend = "gcs"
  config = {
    bucket = var.bucket_name
    prefix = "elk"
  }
}