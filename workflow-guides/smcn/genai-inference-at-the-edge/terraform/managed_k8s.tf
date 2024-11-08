resource "volterra_k8s_cluster" "mk8s" {
  name                                = format("%s-mk8s", var.project_prefix)
  namespace                           = "system"
  use_default_cluster_role_bindings   = true
  use_default_cluster_roles           = true
  use_default_pod_security_admission  = true
  local_access_config {
    local_domain                      = "kubernetes.default.svc"
  }
}

#resource "volterra_cloud_credentials" "aws" {
#  name        = format("%s-cred", var.project_prefix)
#  description = format("AWS credential will be used to create site %s", var.project_prefix)
#  namespace   = "system"
#  aws_secret_key {
#    access_key = var.aws_access_key
#    secret_key {
#      clear_secret_info {
#        url = "string:///${base64encode(var.aws_secret_key)}"
#      }
#    }
#  }
#}

resource "volterra_aws_vpc_site" "this" {
  name        = format("%s-appstack", var.project_prefix)
  namespace   = "system"
  aws_region  = var.aws_region
  ssh_key     = var.ssh_key
  aws_cred {
    #name      = volterra_cloud_credentials.aws.name
    name      = "aws-salini-mktg"
    namespace = "system"
  }
  vpc {
    new_vpc {
      name_tag      = format("%s-vpc", var.project_prefix)
      primary_ipv4  = "10.0.0.0/16"
    }
  }
  disk_size         = "80"
  instance_type     = "t3.xlarge"

  voltstack_cluster {
    aws_certified_hw= "aws-byol-voltstack-combo"
    az_nodes {
      aws_az_name   = format("%sa", var.aws_region)
      local_subnet {
        subnet_param {
          ipv4      = "10.0.0.0/24"
        }
      }
    }
    k8s_cluster {
      name      = volterra_k8s_cluster.mk8s.name
      namespace = "system"
      tenant    = var.xc_tenant
    }
  }
}

resource "null_resource" "wait_for_aws_mns" {
  triggers = {
    depends = volterra_aws_vpc_site.this.id
  }
}

resource "volterra_tf_params_action" "apply_aws_vpc" {
  depends_on       = [null_resource.wait_for_aws_mns]
  site_name        = volterra_aws_vpc_site.this.name
  site_kind        = "aws_vpc_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = true
}
