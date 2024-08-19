resource "volterra_cloud_credentials" "aws_cred" {
  count = var.aws_ce_site ? 1 : 0
  name      = format("%s-aws-creds-%s", local.project_prefix, local.build_suffix)
  namespace = "system"
  aws_secret_key {
    access_key = var.aws_access_key
    secret_key {
      clear_secret_info {
        url = "string:///${base64encode(var.aws_secret_key)}"
      }
    }
  }
}
resource "volterra_aws_vpc_site" "aws_site" {
  count = var.aws_ce_site ? 1 : 0
  name       = "${coalesce(var.site_name, local.project_prefix)}"
  namespace  = "system"
  aws_region = local.aws_region
  aws_cred {
    name      = volterra_cloud_credentials.aws_cred[0].name
    namespace = "system"
  }
  instance_type = "t3.xlarge"
  vpc {
    vpc_id=local.vpc_id
  }
  ingress_gw {
    aws_certified_hw = "aws-byol-voltmesh"
    az_nodes {
      aws_az_name = local.aws_ec2_azs
      disk_size   = 0
      local_subnet {
        existing_subnet_id = local.aws_ec2_subnet
      }
    }
  }
  logs_streaming_disabled = true
  no_worker_nodes         = true
  ssh_key = var.ssh_key
}


resource "null_resource" "validation-wait-aws-ce" {
  count = var.aws_ce_site ? 1 : 0
  provisioner "local-exec" {
    command = "sleep 70"
  }
}


resource "volterra_tf_params_action" "example" {
  count = var.aws_ce_site ? 1 : 0
  depends_on       = [null_resource.validation-wait-aws-ce]
  site_name        = volterra_aws_vpc_site.aws_site[0].name
  site_kind        = "aws_vpc_site"
  action           = "apply"
  wait_for_action  = true
}
