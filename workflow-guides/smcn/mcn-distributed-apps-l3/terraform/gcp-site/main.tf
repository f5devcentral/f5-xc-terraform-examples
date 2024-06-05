terraform {
  required_version = ">= 0.14.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
    volterra = {
      source  = "volterraedge/volterra"
      version = ">=0.11.26"
    }
  }
}

provider "volterra" {
  api_p12_file = var.xc_api_p12_file
  url          = var.xc_api_url
}

provider "google" {
  project = local.gcpProjectId
  region  = local.gcpRegion
}

resource "random_shuffle" "zones" {
  input = data.google_compute_zones.zones.names
  keepers = {
    gcpProjectId = local.gcpProjectId
  }
}


# Import helper module to determine approximate latitude/longitude of GCP regions
module "region_locations" {
  source = "git::https://github.com/memes/terraform-google-volterra//modules/region-locations?ref=0.3.1"
}