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

resource "time_sleep" "wait_for_aws_vpc_creation" {
create_duration = "20s"

depends_on       = [volterra_aws_vpc_site.aws_site]
}

resource "volterra_tf_params_action" "vpc_apply" {
  count = var.aws_ce_site ? 1 : 0
  depends_on       = [time_sleep.wait_for_aws_vpc_creation]
  site_name        = "${coalesce(var.site_name, local.project_prefix)}"
  site_kind        = "aws_vpc_site"
  action           = "apply"
  wait_for_action  = true
}


resource "null_resource" "check_site_status_cert2" {
  count         = var.aws_ce_site == "true" ? 1 : 0
  depends_on       = [volterra_tf_params_action.vpc_apply]
  provisioner "local-exec" {
    command     = format("bash ${path.module}/check_ce_status.sh config/namespaces/system/sites/%s api.p12 %s 3600 cert $VES_P12_PASSWORD", var.site_name, var.xc_tenant)
  }
}