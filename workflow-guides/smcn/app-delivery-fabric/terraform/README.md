# App Delivery Fabric (Secure Multi-Cloud Networking)
--------------------------------------------------------

## Overview

This guide provides both the manual and automated steps for secure app-to-app Multi-Cloud Networking (MCN) connectivity between distributed apps and microservices running in different F5 Distributed Cloud (XC) Customer Edge (CE) deployments. 

Specifically, it showcases two common MCN tasks:

* Deployment of XC CE in two multiple clouds, including set-up of app infrastructure and services deployment;
* Configuration of Load Balancers (LB), advertising options & WAF for secure networking to complete app delivery.

This demonstrates the time-to-value and speed of MCN connectivity for app delivery across different clouds and the configuration of security for distributed apps, independently of where they are running, all managed via a single solution: F5 Distributed Cloud.

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

## GitHub

* **Fork and Clone Repo. Navigate to `Actions` tab and enable it.**

* **Actions Secrets:** Create the following GitHub Actions secrets in your forked repo

| **Variable**         | **Required** | **Description**                                               |
| -------------------- | ------------ | --------------------------------------------------------- |
| AWS_ACCESS_KEY       | true         | AWS Access Key ID                                         |
| AWS_SECRET_KEY       | true         | AWS Secret Access Key                                     |
| AWS_SESSION_TOKEN    | true         | AWS Session Token (optoinal)                              |
| AZURE_CLIENT_ID      | true         | Azure Client ID                                           |
| AZURE_CLIENT_SECRET  | true         | Azure Client Secret                                       |
| AZURE_SUBSCRIPTION_ID| true         | Azure Subscription ID                                     |
| AZURE_TENANT_ID      | true         | Azure Tenant (entranet directory) ID                      |
| TF_API_TOKEN         | true         | Terraform Cloud API Token                                 |
| TF_CLOUD_ORGANIZATION| true         | Terraform Cloud Organization                              |
| XC_API_P12_FILE      | true         | F5 XC P12 certificate ([Base64encoded](https://f5devcentral.github.io/f5-xc-terraform-examples/tools/binary-to-base64-converter/index.html))                     |
| XC_P12_PASSWORD      | true         | F5 XC certificate password                                |
| XC_API_URL           | true         | F5 XC tenant-specific API URL (example: https://yourtenant_here.console.ves.volterra.io/api)                            |

To utilize existing F5 Cloud Credentials for the XC Site, you can define the following environment variables in the GitHub repository. These variables are employed to configure the Terraform variable within the GitHub Actions workflow. You can override the default values by defining the corresponding environment variable in the GitHub repository.

| **Variable**                       | **Required** | **Description**                                               |
| ---------------------------------- | ------------ | --------------------------------------------------------- |
| XC_AWS_CLOUD_CREDENTIALS_NAME      | false        | Name of the F5 XC AWS Cloud Credentials to use instead of creating a new one   |
| XC_AZURE_CLOUD_CREDENTIALS_NAME    | false        | Name of the F5 XC Azure Cloud Credentials to use instead of creating a new one |

## Terraform Cloud

**Terraform cloud must be [configured for local execution](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/settings#execution-mode)**

In the following table are the default names of the Terraform Cloud workspaces used in this project. These names are used to set the Terraform Cloud workspace name in the GitHub Actions workflow. The default values can be overridden by setting the corresponding environment variable in the GitHub repository.

| Variable Name                              | Default Value                           | Description               |
| ------------------------------------------ | --------------------------------------- | ------------------------- |
| TF_CLOUD_WORKSPACE_AWS_CREDENTIALS         | "bookinfo-smcn-aws-credentials"            | AWS credentials state |
| TF_CLOUD_WORKSPACE_AWS_NETWORKING          | "bookinfo-smcn-aws-networking"             | AWS networking state |
| TF_CLOUD_WORKSPACE_AWS_VPC_SITE            | "bookinfo-smcn-aws-vpc-site"               | AWS VPC site state |
| TF_CLOUD_WORKSPACE_SECUREMCN_AWS_EKS       | "bookinfo-smcn-aws-eks"                    | AWS EKS cluster state |
| TF_CLOUD_WORKSPACE_AZURE_NETWORKING        | "bookinfo-smcn-azure-networking"           | Azure networking state |
| TF_CLOUD_WORKSPACE_AZURE_CREDENTIALS       | "bookinfo-smcn-azure-credentials"          | Azure credentials state |
| TF_CLOUD_WORKSPACE_AZURE_VNET_SITE         | "bookinfo-smcn-azure-vnet-site"            | Azure VNET Site state |
| TF_CLOUD_WORKSPACE_SECUREMCN_AZURE_AKS     | "bookinfo-smcn-azure-aks"                  | Azure AKS cluster state |
| TF_CLOUD_WORKSPACE_SECUREMCN_WORKLOAD      | "bookinfo-smcn-workload"                   | Workloads state |

## Action Environment Variables

The following are the default environment variables utilized in the GitHub Actions workflow. These variables serve to establish the Terraform variable within the same workflow. If necessary, you can override these default values by defining the corresponding environment variable in the GitHub repository. We recommend settings the **TF_VAR_prefix** to a unique value to avoid naming conflicts with other deployments.

| Variable                                  | Default Value                                | Description |
| ----------------------------------------- | -------------------------------------------- | ----------- |
| TF_VAR_name                               | "secure-mcn"                                 | The name of the Deployment |
| TF_VAR_prefix                             | ""                                           | The prefix for the Deployment |
| TF_VAR_aws_vpc_site_name                  | "secure-aws-vpc-site"                        | AWS VPC site name |
| TF_VAR_azure_vnet_site_name               | "secure-azure-vpc-site"                      | Azure VNet site name |
| TF_VAR_tags                               | "{\"project\": \"secure-mcn\"}"              | Tags for the project |
| TF_VAR_aws_region                         | "us-east-1"                                  | AWS region |
| TF_VAR_aws_az_names                       | "[\"us-east-1a\"]"                           | AWS availability zone names |
| TF_VAR_azure_location                     | "centralus"                                  | Azure location |
| TF_VAR_azure_resource_group_name          | ""                                           | Azure resource group name |
| TF_VAR_aws_inside_subnets                 | "[\"172.10.21.0/24\"]"                       | AWS inside subnets |
| TF_VAR_aws_outside_subnets                | "[\"172.10.31.0/24\"]"                       | AWS outside subnets |
| TF_VAR_aws_workload_subnets               | "[\"172.10.11.0/24\"]"                       | AWS workload subnets |
| TF_VAR_aws_vpc_cidr                       | "172.10.0.0/16"                              | AWS VPC CIDR |
| TF_VAR_eks_az_names                       | "[\"us-east-1a\", \"us-east-1b\"]"           | EKS availability zone names |
| TF_VAR_eks_internal_cidrs                 | "[\"172.10.211.0/24\", \"172.10.212.0/24\"]" | EKS internal CIDRs |
| TF_VAR_azure_inside_subnets               | "[\"172.10.21.0/24\"]"                       | Azure inside subnets |
| TF_VAR_azure_outside_subnets              | "[\"172.10.31.0/24\"]"                       | Azure outside subnets |
| TF_VAR_azure_vnet_cidr                    | "172.10.0.0/16"                              | Azure VNet CIDR |
| TF_VAR_app_domain                         | "bookinfo.smcn.f5-cloud-demo.com"            | App domain |
| TF_VAR_create_aks_namespace               | "true"                                       | Flag to create AKS namespace |
| TF_VAR_create_eks_namespace               | "true"                                       | Flag to create EKS namespace |
| TF_VAR_create_xc_namespace                | "true"                                       | Flag to create XC namespace |
| TF_VAR_namespace                          | ""                                           | Namespace |


## Workflow Runs

**STEP 1:** Make sure you have the required secrets and environment variables set up in your GitHub repository. We recommend to customize the default values of the `TF_VAR_app_domain` and `TF_VAR_prefix` variables to avoid naming conflicts with other deployments.

**STEP 2:** Open GitHub Actions and select the `Secure Multi-Cloud Networking Apply` workflow. 

**STEP 3:** Select `azure-vnet-site` from the list from the dropdown menu and click `Run workflow`. Wait for the workflow to complete.

**STEP 4:** Select `aws-vpc-site` from the list from the dropdown menu and click `Run workflow`. Wait for the workflow to complete.

**STEP 5:** Open F5 XC Distributed Cloud and navigate to the `Multi-Cloud Network Connect` tab from the main menu. Select the `Sites` section and verify that the sites have been created and fully provisioned.

**STEP 6:** Select `deploy-workloads` from the list from the dropdown menu and click `Run workflow`. Wait for the workflow to complete.

**STEP 7:** Select `enable-waf` from the list from the dropdown menu and click `Run workflow`. Wait for the workflow to complete.

**STEP 8:** In the output of the `enable-waf` workflow, you will find the job `Tests`. Expand the `Test Connection` step and check the output for the curl command. This command will test the connection to the Bookinfo application.

**STEP 9:** Open F5 XC Distributed Cloud and navigate to the `Web App & API Protection` tab from the main menu. Explore `Performance` dashboard to check the connection and traffic to the Bookinfo application. Open `Security` dashboard and check the WAF events.

## Steps to Destroy

1. Open Github Actions and find `Secure Multi-Cloud Networking Destroy` workflow
2. Run workflow and wait for completion
3. Check your clouds for any remaining resources and delete them manually if necessary
