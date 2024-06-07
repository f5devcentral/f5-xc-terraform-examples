Multi-Cloud Networking (MCN) for Distributed Apps with secure L3 Routing
---------------------------------------------------------------------------

## Overview

This guide provides automated steps for a comprehensive Multi-Cloud Networking (MCN) demo focused on:

- Deployment of multi-cloud infrastructure in Amazon AWS, Microsoft Azure, and Google GCP to support a distributed application with its services running on K8s in different clouds;
- Layer 3 networking between all of the services by way of Site Mesh Group (SMG) connecting between several F5 Distributed Cloud (XC) Customer Edge (CE) Sites deployed in each cloud;
- Configuration of Enhanced Firewall between all of the sites with shared rules for consistency and ease of management;
- Configuration of App Firewall to protect inbound traffic for the main app from malicious actors and bots.

## Setup Diagram

![Diagram](./assets/Arcadia%20in%20F5XC-MCN-NetworkConnect.svg)

## Workflow Instructions

The included Terraform scripts are accessible in the [./terraform](./terraform/) directory and will automate all of the necessary deployment and configuration.
You will need to complete the prerequisites including the config of all variables.

## Prerequisites

### Accounts & Services

* [F5 Distributed Cloud Account (F5XC)](https://console.ves.volterra.io/signup/usage_plan)
  * [F5XC API certificate](https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials)
* [Terraform Cloud Account](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started)
* [GitHub Account](https://github.com)
* [AWS Programmatic Access](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user_manage_add-key.html)
* [GCP Programmatic Access](https://cloud.google.com/security-command-center/docs/how-to-programmatic-access)
* [Azure Service Principal with Contributor Role](https://learn.microsoft.com/en-us/cli/azure/azure-cli-sp-tutorial-1?tabs=bash)

### Tools

* **IAC:** Terraform
* **IAC State:** Terraform Cloud
* **CI/CD:** GitHub Actions

### GitHub

* **Fork and Clone Repo. Navigate to the `Actions` tab and enable it.**

* **Actions Secrets:** Create the following GitHub Actions secrets in your forked repo under project `Settings` > `General` > `Security: Secrets and variables` > `Actions` > `Repository secrets`
  
### Action Secret Variables

| Variable             | Description                                               |
| -------------------- | --------------------------------------------------------- |
| AWS_ACCESS_KEY       | AWS Access Key ID                                         |
| AWS_SECRET_KEY       | AWS Secret Access Key                                     |
| AZURE_CLIENT_ID      | Azure Client ID                                           |
| AZURE_CLIENT_SECRET  | Azure Client Secret                                       |
| AZURE_SUBSCRIPTION_ID| Azure Subscription ID                                     |
| AZURE_TENANT_ID      | Azure Tenant (entranet directory) ID                      |
| GOOGLE_ACCOUNT_ID    | Google Account ID                                         |
| GOOGLE_CREDENTIALS   | Credentials to access GCP service account JSON ([base64encoded](https://f5devcentral.github.io/f5-xc-terraform-examples/tools/binary-to-base64-converter/index.html)) |
| GOOGLE_PROJECT_ID    | Existing GCP project id                                   |
| TF_API_TOKEN         | Terraform Cloud API Token                                 |
| TF_CLOUD_ORGANIZATION| Terraform Cloud Organization                              |
| XC_API_P12_FILE      | F5 XC P12 certificate ([base64encoded](https://f5devcentral.github.io/f5-xc-terraform-examples/tools/binary-to-base64-converter/index.html)) |
| XC_API_URL           | F5 XC tenant-specific API URL (example: https://yourtenant_here.console.ves.volterra.io/api)  
| XC_P12_PASSWORD      | F5 XC certificate password                                |

### Action Environment Variables

The following are the default environment variables utilized in the GitHub Actions workflow. These variables serve to establish the Terraform variable within the same workflow. If necessary, you can override these default values by defining the corresponding environment variable in the forked repo under project `Settings` > `General` > `Security: Secrets and variables` > `Actions` > `Repository variables`

| Variable                      | Default Value             | Description |
| ----------------------------- | ------------------------- | ----------- |
| TF_VAR_name                   | "secure-mcn"              | The name of the Deployment |
| TF_VAR_prefix                 | ""                        | The prefix for the Deployment |
| TF_VAR_tags                   | "{\"project\": \"teachable\"}" | The tags associated with the resources |
| TF_VAR_aws_vpc_site_name      | "aws-vpc-site"            | The name of the AWS VPC site |
| TF_VAR_aws_region             | "us-east-1"               | The AWS region |
| TF_VAR_aws_az_names           | "[\"us-east-1a\"]"        | The AWS availability zone names |
| TF_VAR_aws_inside_subnets     | "[\"10.10.11.0/24\"]"     | The inside subnets for the AWS VPC |
| TF_VAR_aws_outside_subnets    | "[\"10.10.31.0/24\"]"     | The outside subnets for the AWS VPC |
| TF_VAR_aws_workload_subnets   | "[\"10.10.21.0/24\"]"     | The workload subnets for the AWS VPC |
| TF_VAR_aws_vpc_cidr           | "10.10.0.0/16"            | The CIDR block for the AWS VPC |
| TF_VAR_aws_vpc_cidr_prefix    | "10.10.0.0"               | The CIDR prefix for the AWS VPC |
| TF_VAR_aws_vpc_cidr_plen      | "16"                      | The CIDR prefix length for the AWS VPC |
| TF_VAR_azure_vnet_site_name   | "azure-vnet-site"         | The name of the Azure VNet site |
| TF_VAR_azure_location         | "centralus"               | The Azure location |
| TF_VAR_azure_resource_group_name | ""                     | The name of the Azure resource group |
| TF_VAR_azure_inside_subnets   | "[\"172.10.21.0/24\"]"    | The inside subnets for the Azure VNet |
| TF_VAR_azure_outside_subnets  | "[\"172.10.31.0/24\"]"    | The outside subnets for the Azure VNet |
| TF_VAR_azure_vnet_cidr        | "172.10.0.0/16"           | The CIDR block for the Azure VNet |
| TF_VAR_azure_vm_private_ip    | "172.10.21.200"           | The private IP for the Azure VM |
| TF_VAR_gcp_slo_cidr           | "100.64.96.0/22"          | The CIDR block for the GCP SLO |
| TF_VAR_gcp_sli_cidr           | "10.3.0.0/16"             | The CIDR block for the GCP SLI |
| TF_VAR_gcp_proxy_cidr         | "100.64.100.0/24"         | The CIDR block for the GCP proxy |
| TF_VAR_cluster_cird           | "100.64.96.0/24"          | The CIDR block for the cluster |
| TF_VAR_services_cird          | "100.64.97.0/24"          | The CIDR block for the services |
| TF_VAR_gcp_region             | "us-central1"             | The GCP region |
| TF_VAR_namespace              | ""                        | The namespace for the Terraform variable |
| TF_VAR_app_domain             | "arcadia-mcn.demo.internal" | The FQDN for the application frontend |
| TF_VAR_f5xc_sd_sa             | "smsn-sd-sa"              | The F5 XC SD SA |
| TF_VAR_xc_mud                 | "true"                    | The XC Malicious User Detection setting |
| TF_VAR_xc_ddos_def            | "true"                    | The XC DDoS defense setting |
| TF_VAR_xc_bot_def             | "true"                    | The XC Bot defense setting |
|TF_VAR_dns_origin_pool         | "true"                    | The DNS origin pool setting |

### XC Cloud Credentials

To use "Cloud Credentials" pre-configured in XC when deploying Customer Edge (CE) Sites, you can define the following as `Repository variables` in GitHub. Use of these variables prevent GitHub from creating new "Cloud Credentials" in XC.

| Variable Name                      |
| ---------------------------------- |
| AWS_CLOUD_CREDENTIALS_TF_VAR_name  |
| AZURE_CLOUD_CREDENTIALS_TF_VAR_name|
| TF_VAR_xc_gcp_cloud_credentials    |

### Cloud & TF Accounts
1. A subscription and owner privilege to each cloud provider: AWS, Azure, GCP
   ### AWS
   IAM user with programmatic access for Terraform (for use by both F5 XC and GitHub)
   ### Azure
   App Registration for Terraform (for use by both F5 XC and GitHub), with the subscription IAM Role of "Owner" and limited ability to assign the Network Contributor role as follows: [^1]
     1. Condition #1 Action: Create or update role assignments
        - Expression:
           Attribute source: **Request**  
           Attribute: **Role definition ID**  
           Operator: **ForAnyOfAnyValues:GuidEquals** (Value)  
           Name: **Network Contributor (BuiltInRole)**  
      2. Condition #2 Action: Delete a role assignment
         - Expression:
           Attribute source: **Request**  
           Attribute: **Role definition ID**  
           Operator: **ForAnyOfAnyValues:GuidEquals**  (Value)  
           Name: **Network Contributor (BuiltInRole)**  
   ### GCP
   Service Account for Terraform (for use by both F5 XC and GitHub) with the following IAM Roles
      - Compute Admin - *Create VM's*
      - Compute Network Admin - *Create networks & subnets*
      - Compute OS Admin Login - *Manage EKS cluster nodes*
      - Compute OS Login - *Automate provisioning of services in EKS cluster nodes*
      - DNS Administrator - *Only when needed to support internal DNS*
      - Logging Admin - *EKS cluster requirement*
      - Monitoring Admin - *EKS cluster requirement*
      - Security Admin - *Create network firewall policies*
      - Service Account Admin - *Create a unique service account to run EKS cluster nodes*

2. Terraform Cloud
- Terraform Cloud Account *to maintain State*
- Terraform Project
- Terraform Workspaces  
Each workspace must be configured for **local execution** and with **remote state sharing** to **all workspaces in the organization**

The following table contains the default names of the Terraform Cloud workspaces used in this project. These names are used to set the Terraform Cloud workspace name in the GitHub Actions workflow. The default values can be overridden by setting the corresponding `Repository variable` in GitHub.

| Variable Name                              | Default Value            | Description               |
| ------------------------------------------ | ------------------------ | ------------------------- |
| TF_CLOUD_WORKSPACE_AWS_CREDENTIALS         | "aws-cloud-credentials"  | AWS Cloud Credentials     |
| TF_CLOUD_WORKSPACE_AWS_NETWORKING          | "aws-networking"         | AWS Networking            |
| TF_CLOUD_WORKSPACE_AWS_VPC_SITE            | "aws-vpc-site"           | AWS VPC Site              |
| TF_CLOUD_WORKSPACE_SECUREMCN_AWS_EKS       | "secure-mcn-aws-eks"     | Secure MCN AWS EKS        |
| TF_CLOUD_WORKSPACE_SECUREMCN_AWS_EKS_NIC   | "secure-mcn-aws-eks-nic" | Secure MCN AWS EKS NIC    |
| TF_CLOUD_WORKSPACE_SECUREMCN_GCP_VPC_SITE  | "secure-mcn-gcp-vpc-site"| Secure MCN GCP VPC Site   |
| TF_CLOUD_WORKSPACE_SECUREMCN_GCP_GKE       | "secure-mcn-gcp-gke"     | Secure MCN GCP GKE        |
| TF_CLOUD_WORKSPACE_SECUREMCN_XC_CONFIG     | "secure-mcn-xc-config"   | Secure MCN XC Config      |
| TF_CLOUD_WORKSPACE_SECUREMCN_WORKLOAD      | "secure-mcn-workload"    | Secure MCN Workload       |
| TF_CLOUD_WORKSPACE_AZURE_NETWORKING        | "azure-networking"       | Azure Networking          |
| TF_CLOUD_WORKSPACE_AZURE_CREDENTIALS       | "azure-cloud-credentials"| Azure Cloud Credentials   |
| TF_CLOUD_WORKSPACE_AZURE_VNET_SITE         | "azure-vnet-site"        | Azure VNET Site           |
| TF_CLOUD_WORKSPACE_SECUREMCN_AZURE_AKS     | "secure-mcn-azure-aks"   | Secure MCN Azure AKS      |

## Steps to Deploy
1. Fork this repository
2. Add all credential names and/or values to the GitHub Action `Repository secrets` and `Repository variables`
3. Open GitHub Actions and find **Secure MCN Apply** workflow
4. *Optional* Enter a prefix to prepend to the name of all resources created by the workflow
5. Run **azure-vnet-site** workflow and wait for completion
6. Run **aws-vpc-site** workflow and wait for completion
7. Run **gcp-vpc-site** workflow and wait for completion
8. Navigate to F5 XC and look for the new sites. Wait until all sites are fully provisioned and ready
9. Run **deploy-resources** workflow and wait for completion

Go to your app at **https://${TF_VAR_app_domain}**

➡️`NOTE` When the domain name for the app is a primary DNS zone in F5 XC, the name of the app will be added to DNS automatically. If you do not have a DNS zone managed by F5 XC you will need to manually configure a record. The public IP address for the app can be found in the XC Console at `Multi-Cloud App Connect` > `Namespace ${TF_VAR_namespace}` > `Load Balancers` > `HTTP Load Balancers`${TF_VAR_prefix}-${TF_VAR_name}-xclb` > `Manage Configuration` > `DNS Information`

## Steps to Destroy
1. Open Github Actions and find **Secure MCN Destroy** workflow
2. *Optional* Enter the same prefix if used in the Deploy workflows
3. Run **deploy-resources** workflow and wait for completion
4. Run **azure-vnet-site** workflow and wait for completion
6. Run **aws-vpc-site** workflow and wait for completion
7. Run **gcp-vpc-site** workflow and wait for completion
8. If any Destroy workflow fails, check your public cloud account for any remaining resources and delete them manually if necessary


[^1]: Necessary to allow the Azure Managed Identity created by Azure for the AKS cluster and kubelet node to create an internal load balancer on the SLO/public subnet

## Known Issues

- Service Discovery will need to be configured to demonstrate ease of discovering/connecting different services;
- WAF and Bot configuration & tuning to be optimized
- Azure: "Network Contributor" Role may fail to be removed from System Managed Identities by Terraform. Manually delete the AKS cluster when this happens
