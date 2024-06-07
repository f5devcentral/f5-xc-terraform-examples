# F5 XC Enhanced Firewall Policy allows traffic ingress with specific AWS specific tag "prefix" with value "my-mcn-demo"
# Also allow well known CIDR blocks. This will eventually be less favorable by additional provider tagging support.

resource "volterra_enhanced_firewall_policy" "mcn_nc_efp" {
    name = format("%s-enh-fw-pol", local.name)
    namespace = "system"
    disable = false
        rule_list {
            rules {
                metadata {
                    name = "allow-all-egress"
                }
                allow = true

                source_prefix_list {
                    prefixes = [
                        "${local.aws_vpc_cidr}", // AWS
                        "${local.azure_vnet_cidr}", // Azure
                        "${local.gcp_vnet_proxy_cird}" // GCP
                    ]
                }
                outside_destinations = true
                all_traffic = true

                label_matcher {
                    keys = []
                }

                advanced_action {
                    action = "LOG"
                }
            }

            rules {
                metadata {
                    name = "allow-azure-to-aws"
                }
                allow = true
                advanced_action {
                    action = "LOG"
                }
                source_prefix_list {
                    prefixes = [
                        "${local.azure_vnet_cidr}"
                    ]
                }
                destination_prefix_list {
                    prefixes = [
                        "${local.aws_vpc_cidr}"
                    ]
                }
                applications {
                    applications = [
                        "APPLICATION_HTTP",
                        "APPLICATION_DNS"
                    ]
                }
                label_matcher {
                    keys = []
                }
            }

            rules {
                metadata {
                    name = "allow-aws-to-azure"
                }
                allow = true
                advanced_action {
                    action = "LOG"
                }
                source_prefix_list {
                    prefixes = [
                        "${local.aws_vpc_cidr}"
                    ]
                }
                destination_prefix_list {
                    prefixes = [
                        "${local.azure_vnet_cidr}"
                    ]
                }
                applications {
                    applications = [
                        "APPLICATION_HTTP",
                        "APPLICATION_DNS"
                    ]
                }
                label_matcher {
                    keys = []
                }
            }

            rules {
                metadata {
                    name = "deny-all"
                }
                deny = true
                advanced_action {
                    action = "LOG"
                }
                label_matcher {
                    keys = []
                }
            }
        }
}