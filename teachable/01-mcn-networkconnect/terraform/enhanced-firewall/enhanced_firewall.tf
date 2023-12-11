locals {
  enhanced_firewall_policy_name      = ("" != var.prefix) ? format("%s-%s", var.prefix, var.name) : var.name
  enhanced_firewall_policy_namespace = "system"
}

resource "volterra_enhanced_firewall_policy" "aws_fw_rules" {
  name      = local.enhanced_firewall_policy_name
  namespace = local.enhanced_firewall_policy_namespace

  rule_list {
    rules {
      metadata {
        name = "allow-ingress-web"
      }

      all_sources = true
      allow       = true

      destination_aws_vpc_ids {
        vpc_id = [ var.aws_vpc_id ]
      }

      applications {
        applications = [ "APPLICATION_HTTP", "APPLICATION_HTTPS" ]
      }
    }

    rules {
      metadata {
        name = "allow-egress-all"
      }

      all_destinations = true
      allow            = true

      source_aws_vpc_ids {
        vpc_id = [ var.aws_vpc_id ]
      }
    }

    rules {
      all_sources = true
      deny        = true

      metadata {
        name = "deny-other"
      }

      destination_aws_vpc_ids {
        vpc_id = [ var.aws_vpc_id ]
      }
    }
  }
}