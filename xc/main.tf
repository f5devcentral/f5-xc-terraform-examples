provider "volterra" {
    url   = var.api_url
}

# Create a random id if infra is xc vk8s
resource "random_id" "build_suffix" {
  byte_length = 2
}
