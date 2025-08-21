# F5 Distributed Cloud Azure VNET Site

## Prerequisites

### For CI/CD

* [F5 Distributed Cloud Account (F5XC)](https://console.ves.volterra.io/signup/usage_plan)
  * [F5XC API certificate](https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials)
* [Terraform Cloud Account](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started)
* [GitHub Account](https://github.com)
* [Azure Service Principal with Contributor Role](https://learn.microsoft.com/en-us/cli/azure/azure-cli-sp-tutorial-1?tabs=bash)

## Tools

* **IAC:** Terraform
* **IAC State:** Terraform Cloud
* **CI/CD:** GitHub Actions

## Terraform Cloud

* **Workspaces:** The following workspaces will be created in Terraform Cloud unless otherwise specified in the Actions Environments.


  | **Workflow**                | **Assets/Workspaces**  |
  | ----------------------------| ---------------------- |
  | azure-vnet-site-apply       | azure-vnet-site        |
  
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
  | AZURE_SUBSCRIPTION_ID              | true         | Azure subscription ID                                                       |
  | AZURE_TENANT_ID                    | true         | Azure tenant ID                                                             |
  | AZURE_CLIENT_ID                    | true         | Azure client ID                                                             |
  | AZURE_CLIENT_SECRET                | true         | Azure client secret                                                         |
  | XC_AZURE_CLOUD_CREDENTIALS_NAME      | true         | Name of the F5 XC API certificate to use instead of creating a new one      |

* **Actions Environemnt:** Optionally create the following GitHub Actions environments in your forked repo

Complex values are represented as an encoded json strings. For example:

```json
  "TF_VAR_master_nodes_az_names": "[\"1\",\"2\",\"3\]"
```

The full input parameters list can be found in the [azure-vnet-site module inputs](https://registry.terraform.io/modules/f5devcentral/azure-vnet-site/xc/latest?tab=inputs).

  | **Name**                                 | **Default**           | **Description**                                  |
  | ---------------------------------------- | --------------------- | ------------------------------------------------ |
  | TF_VAR_name                              | azure-vnet-site       | Name for the resources                           |
  | TF_VAR_prefix                            |                       | Prefix for the resources                         |
  | TF_CLOUD_WORKSPACE_AZURE_VNET_SITE       | azure-vnet-site       | Name of the Terraform Cloud workspace            |
  | site_description                         |                       | Description of the site                          |
  | site_namespace                           | system                | Namespace of the site                            |
  | tags                                     |                       | Tags for the resources                           |
  | offline_survivability_mode               |                       | Offline survivability mode                       |
  | software_version                         |                       | Software version                                 |
  | operating_system_version                 |                       | Operating system version                         |
  | site_type                                | ingress_gw            | Type of the site                                 |
  | master_nodes_az_names                    | []                    | Availability zone names for master nodes         |
  | nodes_disk_size                          | 80                    | Disk size for the nodes                          |
  | ssh_key                                  |                       | SSH key                                          |
  | azure_rg_location                        |                       | Azure resource group location                    |
  | azure_rg_name                            |                       | Azure resource group name                        |
  | machine_type                             | Standard_D3_v2        | Machine type                                     |
  | az_cloud_credentials_name                |                       | Name of the Azure cloud credentials              |
  | az_cloud_credentials_namespace           |                       | Namespace of the Azure cloud credentials         |
  | az_cloud_credentials_tenant              |                       | Tenant of the Azure cloud credentials            |
  | jumbo                                    |                       | Jumbo                                            |
  | log_receiver                             |                       | Log receiver                                     |
  | vnet_name                                |                       | Name of the VNET                                 |
  | vnet_rg_name                             |                       | Resource group of the VNET                       |
  | vnet_rg_location                         |                       | Location of the VNET                             |
  | vnet_cidr                                |                       | CIDR of the VNET                                 |
  | apply_outside_sg_rules                   | true                  | Apply outside security group rules               |
  | existing_inside_rt_names                 | []                    | Existing inside route table names                |
  | existing_local_subnets                   | []                    | Existing local subnets                           |
  | existing_inside_subnets                  | []                    | Existing inside subnets                          |
  | existing_outside_subnets                 | []                    | Existing outside subnets                         |
  | local_subnets                            | []                    | Local subnets                                    |
  | inside_subnets                           | []                    | Inside subnets                                   |
  | outside_subnets                          | []                    | Outside subnets                                  |
  | worker_nodes_per_az                      | 0                     | Number of worker nodes per availability zone     |
  | block_all_services                       | true                  | Block all services                               |
  | blocked_service                          |                       | Blocked service                                  |
  | dc_cluster_group_inside_vn               |                       | DC cluster group inside VN                       |
  | dc_cluster_group_outside_vn              |                       | DC cluster group outside VN                      |
  | active_forward_proxy_policies_list       | []                    | Active forward proxy policies list               |
  | forward_proxy_allow_all                  |                       | Forward proxy allow all                          |
  | global_network_connections_list          | []                    | Global network connections list                  |
  | inside_static_route_list                 | []                    | Inside static route list                         |
  | outside_static_route_list                | []                    | Outside static route list                        |
  | enhanced_firewall_policies_list          | []                    | Enhanced firewall policies list                  |
  | active_network_policies_list             | []                    | Active network policies list                     |
  | sm_connection_public_ip                  |                       | SM connection public IP                          |


## Worflow Outputs

  | **Name**                      | **Description**                              |
  | ----------------------------- | -------------------------------------------- |
  | id                            | ID of the VPC Site                           |
  | name                          | Name of the VPC Site                         |
  | ssh_private_key_pem           | SSH private key in PEM format                |
  | ssh_private_key_openssh       | SSH private key in OpenSSH format            |
  | ssh_public_key                | SSH public key                               |
  | apply_tf_output               | Output of the Terraform apply command        |
  | apply_tf_output_map           | Output of the Terraform apply command as map |
  | master_nodes_az_names         | Availability zone names for master nodes     |
  | vnet_resource_group           | Resource group of the VNET                   |
  | vnet_name                     | Name of the VNET                             |
  | inside_rt_names               | Names of the inside route tables             |
  | location                      | Location of the VPC Site                     |
  | site_resource_group           | Resource group of the VPC Site               |
  | sli_nic_ids                   | NIC IDs of the SLI nodes                     |
  | sli_nic_names                 | NIC names of the SLI nodes                   |
  | sli_nic_private_ips           | Private IPs of the SLI nodes                 |
  | slo_nic_ids                   | NIC IDs of the SLO nodes                     |
  | slo_nic_names                 | NIC names of the SLO nodes                   |
  | slo_nic_private_ips           | Private IPs of the SLO nodes                 |
  | slo_nic_public_ips            | Public IPs of the SLO nodes                  |

## Workflow Runs

**STEP 1:** Open GitHub Actions and select the "Azure VNET Site Apply" workflow. Fill required parameters, click "Run Workflow" and select the branch you want to run the workflow on.

  **DEPLOY**
  
  | Workflow                         | Name                           |
  | -------------------------------- | ------------------------------ |
  | azure-vnet-site-apply.yaml       | Azure VNET Site Apply          |
 
  **DESTROY**
  
  | Workflow                           | Name                             |
  | ---------------------------------- | -------------------------------- |
  | azure-vnet-site-destroy.yaml       | Azure VNET Site Destroy          |