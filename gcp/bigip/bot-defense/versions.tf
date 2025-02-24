terraform {
  required_providers {
    bigip = {
      source = "F5Networks/bigip"
      version = ">=1.22.4"
    }
  }
  required_version = ">= 0.14.0"
}
