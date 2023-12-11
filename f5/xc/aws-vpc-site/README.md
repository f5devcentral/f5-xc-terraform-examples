# F5 Distributed Cloud AWS VPC Site

## Prerequisites

### For CI/CD

* [F5 Distributed Cloud Account (F5XC)](https://console.ves.volterra.io/signup/usage_plan)
  * [F5XC API certificate](https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials)
* [Terraform Cloud Account](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started)
* [GitHub Account](https://github.com)
* [AWS Programmatic Access](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user_manage_add-key.html)

## Tools

* **IAC:** Terraform
* **IAC State:** Terraform Cloud
* **CI/CD:** GitHub Actions

## Terraform Cloud

* **Workspaces:** The following workspaces will be created in Terraform Cloud unless otherwise specified in the Actions Environments.


  | **Workflow**                | **Assets/Workspaces**  |
  | ----------------------------| ---------------------- |
  | aws-vpc-site-apply          | aws-vpc-site           |
  
## GitHub

* **Fork and Clone Repo. Navigate to `Actions` tab and enable it.**

* **Actions Secrets:** Create the following GitHub Actions secrets in your forked repo


  | **Name**                           | **Required** | **Description**                                                             |
  | ---------------------------------- | ------------ | --------------------------------------------------------------------------- |
  | TF_API_TOKEN                       | true         | Your Terraform Cloud API token                                              |
  | TF_CLOUD_ORGANIZATION              | true         | Your Terraform Cloud Organization name                                      |
  | XC_API_P12_FILE                    | true         | Base64 encoded F5XC API certificate                                         |
  | XC_P12_PASSWORD                    | true         | Password for F5XC API certificate                                           |
  | XC_API_URL                         | true         | URL for F5XC API                                                            |
  | AWS_ACCESS_KEY                     | true         | AWS access key for the account                                              |
  | AWS_SECRET_KEY                     | true         | AWS secret key for the account                                              |
  | AWS_SESSION_TOKEN                  | true         | AWS session token for the account                                           |
  | XC_AWS_CLOUD_CREDENTIALS_NAME      | true         | Name of the F5 XC API certificate to use instead of creating a new one      |

* **Actions Environemnt:** Optionally create the following GitHub Actions environments in your forked repo

Complex values are represented as an encoded json strings. For example:

```json
  "TF_VAR_master_nodes_az_names": "[\"us-east-1a\"]"
```

The full input parameters list can be found in the [aws-vpc-site module inputs](https://registry.terraform.io/modules/f5devcentral/aws-vpc-site/xc/latest?tab=inputs).

  | **Name**                                        | **Default**            | **Description**                                  |
  | ----------------------------------------------- | ---------------------- | ------------------------------------------------ |
  | TF_VAR_name                                     | aws-vpc-site           | Name for the resources                           |
  | TF_VAR_prefix                                   |                        | Prefix for the resources                         |
  | TF_CLOUD_WORKSPACE_AWS_VPC_SITE                 | aws-vpc-site           | Name of the Terraform Cloud workspace            |
  | TF_VAR_aws_region                               |                        | AWS region for the resources                     |
  | TF_VAR_aws_cloud_credentials_name               |                        | Name of the AWS cloud credentials                |
  | TF_VAR_aws_cloud_credentials_namespace          |                        | Namespace of the AWS cloud credentials           |
  | TF_VAR_aws_cloud_credentials_tenant             |                        | Tenant of the AWS cloud credentials              |
  | TF_VAR_site_description                         |                        | Description of the site                          |
  | TF_VAR_site_namespace                           | system                 | Namespace of the site                            |
  | TF_VAR_tags                                     |                        | Tags for the resources                           |
  | TF_VAR_offline_survivability_mode               |                        | Offline survivability mode                       |
  | TF_VAR_software_version                         |                        | Software version                                 |
  | TF_VAR_operating_system_version                 |                        | Operating system version                         |
  | TF_VAR_site_type                                | ingress_gw             | Type of the site                                 |
  | TF_VAR_master_nodes_az_names                    | []                     | Availability zone names for master nodes         |
  | TF_VAR_nodes_disk_size                          | 80                     | Disk size for the nodes                          |
  | TF_VAR_ssh_key                                  |                        | SSH key for the resources                        |
  | TF_VAR_instance_type                            | t3.xlarge              | Instance type for the resources                  |
  | TF_VAR_jumbo                                    |                        | Jumbo configuration                              |
  | TF_VAR_direct_connect                           |                        | Direct connect configuration                     |
  | TF_VAR_egress_nat_gw                            |                        | Egress NAT gateway configuration                 |
  | TF_VAR_egress_virtual_private_gateway           |                        | Egress virtual private gateway configuration     |
  | TF_VAR_enable_internet_vip                      |                        | Enable internet VIP                              |
  | TF_VAR_allowed_vip_port                         | { "disable_allowed_vip_port": true }  | Allowed VIP port                  |
  | TF_VAR_allowed_vip_port_sli                     | { "disable_allowed_vip_port": true }  | Allowed VIP port SLI              |
  | TF_VAR_log_receiver                             |                        | Log receiver                                     |
  | TF_VAR_vpc_id                                   |                        | VPC ID                                           |
  | TF_VAR_vpc_name                                 |                        | VPC name                                         |
  | TF_VAR_vpc_allocate_ipv6                        |                        | Allocate IPv6 for the VPC                        |
  | TF_VAR_vpc_cidr                                 |                        | VPC CIDR                                         |
  | TF_VAR_create_aws_vpc                           | true                   | Create AWS VPC                                   |
  | TF_VAR_custom_security_group                    |                        | Custom security group                            |
  | TF_VAR_existing_local_subnets                   | []                     | Existing local subnets                           |
  | TF_VAR_existing_inside_subnets                  | []                     | Existing inside subnets                          |
  | TF_VAR_existing_outside_subnets                 | []                     | Existing outside subnets                         |
  | TF_VAR_existing_workload_subnets                | []                     | Existing workload subnets                        |
  | TF_VAR_local_subnets                            | []                     | Local subnets                                    |
  | TF_VAR_inside_subnets                           | []                     | Inside subnets                                   |
  | TF_VAR_outside_subnets                          | []                     | Outside subnets                                  |
  | TF_VAR_workload_subnets                         | []                     | Workload subnets                                 |
  | TF_VAR_local_subnets_ipv6                       | []                     | Local subnets IPv6                               |
  | TF_VAR_inside_subnets_ipv6                      | []                     | Inside subnets IPv6                              |
  | TF_VAR_outside_subnets_ipv6                     | []                     | Outside subnets IPv6                             |
  | TF_VAR_workload_subnets_ipv6                    | []                     | Workload subnets IPv6                            |
  | TF_VAR_worker_nodes_per_az                      | 0                      | Number of worker nodes per availability zone     |
  | TF_VAR_block_all_services                       | true                   | Block all services                               |
  | TF_VAR_blocked_service                          |                        | Blocked service                                  |
  | TF_VAR_apply_action_wait_for_action             | true                   | Wait for action on apply                         |
  | TF_VAR_apply_action_ignore_on_update            | true                   | Ignore on update on apply                        |
  | TF_VAR_dc_cluster_group_inside_vn               |                        | DC cluster group inside VN                       |
  | TF_VAR_dc_cluster_group_outside_vn              |                        | DC cluster group outside VN                      |
  | TF_VAR_active_forward_proxy_policies_list       | []                     | Active forward proxy policies list               |
  | TF_VAR_forward_proxy_allow_all                  |                        | Forward proxy allow all                          |
  | TF_VAR_global_network_connections_list          | []                     | Global network connections list                  |
  | TF_VAR_inside_static_route_list                 | []                     | Inside static route list                         |
  | TF_VAR_outside_static_route_list                | []                     | Outside static route list                        |
  | TF_VAR_enhanced_firewall_policies_list          | []                     | Enhanced firewall policies list                  |
  | TF_VAR_active_network_policies_list             | []                     | Active network policies list                     |
  | TF_VAR_sm_connection_public_ip                  | true                   | SM connection public IP                          |
  | TF_VAR_vpc_instance_tenancy                     | default                | VPC instance tenancy                             |
  | TF_VAR_vpc_enable_dns_hostnames                 | true                   | Enable DNS hostnames for the VPC                 |
  | TF_VAR_vpc_enable_dns_support                   | true                   | Enable DNS support for the VPC                   |
  | TF_VAR_vpc_enable_network_address_usage_metrics | false                  | Enable network address usage metrics for the VPC |

## Worflow Outputs

  | **Name**                      | **Description**                              |
  | ----------------------------- | -------------------------------------------- |
  | id                            | ID of the VPC Site                           |
  | name                          | Name of the VPC Site                         |
  | ssh_private_key_pem           | SSH private key in PEM format                |
  | ssh_private_key_openssh       | SSH private key in OpenSSH format            |
  | ssh_public_key                | SSH public key                               |
  | apply_tf_output               | Raw output of the Terraform apply action     |
  | apply_tf_output_map           | Output of the Terraform apply command as map |
  | vpc_id                        | ID of the VPC                                |
  | vpc_cidr                      | CIDR block of the VPC                        |
  | outside_subnet_ids            | IDs of the outside subnets                   |
  | outside_route_table_ids       | IDs of the outside route tables              |
  | inside_subnet_ids             | IDs of the inside subnets                    |
  | inside_route_table_ids        | IDs of the inside route tables               |
  | workload_subnet_ids           | IDs of the workload subnets                  |
  | workload_route_table_ids      | IDs of the workload route tables             |
  | local_subnet_ids              | IDs of the local subnets                     |
  | local_route_table_ids         | IDs of the local route tables                |
  | internet_gateway_id           | ID of the internet gateway                   |
  | outside_security_group_id     | ID of the outside security group             |
  | inside_security_group_id      | ID of the inside security group              |

## Workflow Runs

**STEP 1:** Open GitHub Actions and select the "AWS VPC Site Apply" workflow. Fill required parameters, click "Run Workflow" and select the branch you want to run the workflow on.

  **DEPLOY**
  
  | Workflow                         | Name                           |
  | -------------------------------- | ------------------------------ |
  | aws-vpc-site-apply.yaml          | AWS VPC Site Apply             |
 
  **DESTROY**
  
  | Workflow                           | Name                             |
  | ---------------------------------- | -------------------------------- |
  | aws-vpc-site-destroy.yaml          | AWS VPC Site Destroy             |