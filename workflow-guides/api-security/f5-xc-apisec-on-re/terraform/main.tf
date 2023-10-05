provider "volterra" {
  url = var.api_url
}

# Create a random id
resource "random_id" "build_suffix" {
  byte_length = 2
}
