# Teachable - 01-MCN-NetworkConnect

## Prerequisites

### For CI/CD

* [F5 Distributed Cloud Account (F5XC)](https://console.ves.volterra.io/signup/usage_plan)
  * [F5XC API certificate](https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials)
* [Terraform Cloud Account](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started)
* [GitHub Account](https://github.com)
* [AWS Programmatic Access](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user_manage_add-key.html)
* [Azure Service Principal with Contributor Role](https://learn.microsoft.com/en-us/cli/azure/azure-cli-sp-tutorial-1?tabs=bash)

## Tools

* **IAC:** Terraform
* **IAC State:** Terraform Cloud
* **CI/CD:** GitHub Actions

## Terraform Cloud

* **Workspaces:** The following workspaces will be created in Terraform Cloud unless otherwise specified in the Actions Environments.

  | **Workflow**                          | **Assets/Workspaces**   |
  | --------------------------------------| ----------------------- |
  | teachable-01-mcn-networkconnect-apply | teachable-01-mcn        |
  | teachable-01-mcn-networkconnect-apply | teachable-01-mcn-fw     |
  | aws-cloud-credentials-apply           | aws-cloud-credentials   |
  | aws-vpc-site-apply                    | aws-vpc-site            |
  | aws-networking-apply                  | aws-networking          |
  | azure-cloud-credentials-apply         | azure-cloud-credentials |
  | azure-vnet-site-apply                 | azure-vnet-site         |
  | azure-netorking-apply                 | azure-networking        |
  
## Configuration

The configuration described in the `00-intro` teachable. Please refer to the [README.md](../00-intro/README.md) for more information.

## GitHub

* **Fork and Clone Repo. Navigate to `Actions` tab and enable it.**

* **Actions Secrets:** Create the following GitHub Actions secrets in your forked repo


  | **Name**                           | **Required** | **Description**                                                                |
  | ---------------------------------- | ------------ | ------------------------------------------------------------------------------ |
  | TF_API_TOKEN                       | true         | Your Terraform Cloud API token                                                 |
  | TF_CLOUD_ORGANIZATION              | true         | Your Terraform Cloud Organization name                                         |
  | XC_API_P12_FILE                    | true         | Base64 encoded F5XC API certificate                                            |
  | XC_P12_PASSWORD                    | true         | Password for F5XC API certificate                                              |
  | XC_API_URL                         | true         | URL for F5XC API                                                               |
  | AWS_ACCESS_KEY                     | true         | AWS access key                                                                 |
  | AWS_SECRET_KEY                     | true         | AWS secret key                                                                 |
  | AZURE_SUBSCRIPTION_ID              | true         | Azure subscription ID                                                          |
  | AZURE_TENANT_ID                    | true         | Azure tenant ID                                                                |
  | AZURE_CLIENT_ID                    | true         | Azure client ID                                                                |
  | AZURE_CLIENT_SECRET                | true         | Azure client                                                                   |
  | XC_AWS_CLOUD_CREDENTIALS_NAME      | false        | Name of the F5 XC AWS Cloud Credentials to use instead of creating a new one   |
  | XC_AZURE_CLOUD_CREDENTIALS_NAME    | false        | Name of the F5 XC Azure Cloud Credentials to use instead of creating a new one |


* **Actions Environemnt:** Create the following GitHub Actions environments in your forked repo if you want to override the defaults.


  | **Name**                             | **Default**              | **Description**                                                                |
  | ------------------------------------ | ------------------------ | ------------------------------------------------------------------------------ |
  | TF_VAR_name                          | teachable-mcn            | Name for the resources                                                         |
  | TF_VAR_prefix                        |                          | Prefix for the resources                                                       |
  | TF_CLOUD_WORKSPACE_TEACHABLE_MCN     | teachable-01-mcn         | Terraform Cloud workspace for 01-mcn-networkconnect                             |
  | TF_CLOUD_WORKSPACE_TEACHABLE_MCN_FW  | teachable-01-mcn-fw      | Terraform Cloud workspace for 01-mcn-networkconnect                             |
  | TF_CLOUD_WORKSPACE_AWS_CREDENTIALS   | aws-cloud-credentials    | Terraform Cloud workspace for aws-cloud-credentials                            |
  | TF_CLOUD_WORKSPACE_AWS_NETWORKING    | aws-networking           | Terraform Cloud workspace for aws-networking                                   |
  | TF_CLOUD_WORKSPACE_AWS_VPC_SITE      | aws-vpc-site             | Terraform Cloud workspace for aws-vpc-site                                     |
  | AWS_CLOUD_CREDENTIALS_TF_VAR_name    | aws-cloud-credentials    | Name that will be passed to the AWS "aws-cloud-credentials-apply" workflow     |
  | AWS_NETWORKING_TF_VAR_name           | aws-networking           | Name that will be passed to the AWS "aws-networking-apply" workflow            |
  | TF_VAR_aws_vpc_site_name             | aws-vpc-site             | Name for the AWS VPC site                                                      |
  | TF_VAR_tags                          | {"project": "teachable"} | Tags for the resources                                                         |
  | TF_VAR_aws_region                    | us-east-1                | AWS region to deploy resources                                                 |
  | TF_VAR_aws_az_names                  | ["us-east-1a"]           | List of availability zone names for AWS                                        |
  | TF_VAR_aws_inside_subnets            | ["10.10.11.0/24"]        | List of inside subnets for AWS                                                 |
  | TF_VAR_aws_outside_subnets           | ["10.10.31.0/24"]        | List of outside subnets for AWS                                                |
  | TF_VAR_aws_workload_subnets          | ["10.10.21.0/24"]        | List of workload subnets for AWS                                               |
  | TF_VAR_aws_vpc_cidr                  | 10.10.0.0/16             | CIDR block for the AWS VPC                                                     |
  | TF_CLOUD_WORKSPACE_AZURE_NETWORKING  | azure-networking         | Terraform Cloud workspace for azure-networking                                 |
  | TF_CLOUD_WORKSPACE_AZURE_CREDENTIALS | azure-cloud-credentials  | Terraform Cloud workspace for azure-cloud-credentials                          |
  | TF_CLOUD_WORKSPACE_AZURE_VNET_SITE   | azure-vnet-site          | Terraform Cloud workspace for azure-vnet-site                                  |
  | AZURE_CLOUD_CREDENTIALS_TF_VAR_name  | azure-cloud-credentials  | Name that will be passed to the Azure "azure-cloud-credentials-apply" workflow |
  | AZURE_NETWORKING_TF_VAR_name         |                          | Name that will be passed to the Azure "azure-networking-apply" workflow        |
  | TF_VAR_azure_vnet_site_name          | azure-vnet-site          | Name for the Azure VNet site                                                   |
  | TF_VAR_azure_location                | centralus                | Azure region to deploy resources                                               |
  | TF_VAR_azure_resource_group_name     |                          | Name for the Azure resource group                                              |
  | TF_VAR_azure_inside_subnets          | ["172.10.21.0/24"]       | List of inside subnets for Azure                                               |
  | TF_VAR_azure_outside_subnets         | ["172.10.31.0/24"]       | List of outside subnets for Azure                                              |
  | TF_VAR_azure_vnet_cidr               | 172.10.0.0/16            | CIDR block for the Azure VNet                                                  |
  | TF_VAR_aws_vm_private_ip             | 10.10.21.100             | Private IP address for the AWS VM                                              |
  | TF_VAR_azure_vm_private_ip           | 172.10.21.100            | Private IP address for the Azure VM                                            |


## Workflow Runs

**STEP 1:** Open GitHub Actions and select the `Teachable 01-mcn-networkconnect Apply` workflow. 

**STEP 2:** Select Lesson from the list from the dropdown menu.

  **LESSONS**
  
  | **Lesson**          | **Description**                                |
  | ------------------- | ---------------------------------------------- |
  | azure-vnet-site     | Describes how to create an Azure VNET Site.    |
  | aws-vpc-site        | Describes how to create an AWS VPC Site.       |
  | global-network      | Describes how to create a XC Global Network.   |
  | enhanced-firewall   | Describes how to create an Enhanced Firewall.  |

**STEP 3:** Optionally update `Deployment name` and `Prefix`.

**STEP 4:** Click `Run Workflow` 

**STEP 5:** Repeat steps 1-4 for each lesson.

**STEP 6:** Run the `Teachable 01-mcn-networkconnect Destroy` workflow to destroy all resources created by the `Teachable 01-mcn-networkconnect Apply` workflow.
