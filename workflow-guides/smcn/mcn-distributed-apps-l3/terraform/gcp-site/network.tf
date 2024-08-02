# Create an inside VPC for each business unit, with a single regional subnet in each
module "inside" {
  source                                 = "terraform-google-modules/network/google"
  version                                = ">= 9.0.0"
  project_id                             = local.gcpProjectId
  network_name                           = format("%s-inside", local.name)
  description                            = format("Shared inside VPC (%s)", local.name)
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  mtu                                    = "1460"
  routing_mode                           = "REGIONAL"
  subnets = [
    {
      subnet_name           = format("%s-inside", local.name)
      subnet_ip             = local.sli_cird
      subnet_region         = local.gcpRegion
      subnet_private_access = false
    }
  ]
}

# Create a single outside VPC with a single regional subnet
module "outside" {
  source                                 = "terraform-google-modules/network/google"
  version                                = ">= 9.0.0"
  project_id                             = local.gcpProjectId
  network_name                           = format("%s-outside", local.name)
  description                            = format("Shared outside VPC (%s)", local.name)
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  mtu                                    = 1460
  routing_mode                           = "REGIONAL"
  subnets = [
    {
      subnet_name           = format("%s-outside", local.name)
      subnet_ip             = local.slo_cidr
      subnet_region         = local.gcpRegion
      subnet_private_access = true
    },
    # Subnet designated to internal load balancing
    {
      subnet_name           = format("%s-proxy-only", local.name)
      subnet_ip             = local.proxy_cidr
      subnet_region         = local.gcpRegion
      subnet_private_access = false
      purpose = "REGIONAL_MANAGED_PROXY"
      role = "ACTIVE"
    }
  ]
  firewall_rules = [
    {
      name		= format("%s-allow-proxy-subnet-ingress", local.name)
      direction		= "INGRESS"
      ranges		= [ local.slo_cidr ]
      allow = [{
        protocol = "all"
        ports = []
      }]
    },
    {
      name		= format("%s-allow-remote-internal-networks-ingress", local.name)
      direction		= "INGRESS"
      ranges		= local.allowed_remote_networks_cidr
      allow = [{
        protocol = "all"
        ports = []
      }]      
    },
    {
      name		= format("%s-allow-health-checks", local.name)
      direction		= "INGRESS"
      // Health Check sources for External and Global LB resources
      ranges		= local.allowed_health_check_sources
      allow = [{
        protocol = "all"
        ports = []
      }]         
    }

  ]
}