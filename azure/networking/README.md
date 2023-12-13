# F5 Distributed Cloud Azure Networking

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
  | azure-networking            | azure-networking       |
  
## GitHub

* **Fork and Clone Repo. Navigate to `Actions` tab and enable it.**

* **Actions Secrets:** Create the following GitHub Actions secrets in your forked repo


  | **Name**                           | **Required** | **Description**                             |
  | ---------------------------------- | ------------ | ------------------------------------------- |
  | TF_API_TOKEN                       | true         | Your Terraform Cloud API token              |
  | TF_CLOUD_ORGANIZATION              | true         | Your Terraform Cloud Organization name      |
  | AZURE_SUBSCRIPTION_ID              | true         | Azure subscription ID                       |
  | AZURE_TENANT_ID                    | true         | Azure tenant ID                             |
  | AZURE_CLIENT_ID                    | true         | Azure client ID                             |
  | AZURE_CLIENT_SECRET                | true         | Azure client secret                         |

* **Actions Environemnt:** Optionally create the following GitHub Actions environments in your forked repo

Complex values are represented as an encoded json strings. For example:

```json
  "TF_VAR_local_subnets": "[\"10.172.11.0/24\", \"10.172.12.0/24\", \"10.172.13.0/24\"]"
```

The full input parameters list can be found in the [azure-vnet-site-networking module inputs](https://registry.terraform.io/modules/f5devcentral/azure-vnet-site-networking/xc/latest?tab=inputs).


  | Name                                   | Default          | Description                                 |
  | -------------------------------------- | ---------------- | ------------------------------------------- |
  | TF_VAR_name                            | azure-networking | Name for the resources                      |
  | TF_VAR_prefix                          |                  | Prefix for the resources                    |
  | TF_CLOUD_WORKSPACE_AZURE_NETWORKING    | azure-networking | Name of the Terraform Cloud workspace       |
  | TF_VAR_location                        | centralus        | Location for the resources                  |
  | TF_VAR_resource_group_name             | azure-networking | Resource group name                         |
  | TF_VAR_create_vnet                     | true             | Create VNet flag                            |
  | TF_VAR_create_resource_group           | true             | Create resource group flag                  |
  | TF_VAR_create_outside_route_table      | true             | Create outside route table flag             |
  | TF_VAR_create_outside_security_group   | true             | Create outside security group flag          |
  | TF_VAR_create_inside_route_table       | true             | Create inside route table flag              |
  | TF_VAR_create_inside_security_group    | true             | Create inside security group flag           |
  | TF_VAR_create_udp_security_group_rules | true             | Create UDP security group rules flag        |
  | TF_VAR_tags                            | {}               | Tags for the resources                      |
  | TF_VAR_local_subnets                   | ["10.172.11.0/24", "10.172.12.0/24", "10.172.13.0/24"] | Local subnets   |
  | TF_VAR_inside_subnets                  | ["10.172.21.0/24", "10.172.22.0/24", "10.172.23.0/24"] | Inside subnets  |
  | TF_VAR_outside_subnets                 | ["10.172.31.0/24", "10.172.32.0/24", "10.172.33.0/24"] | Outside subnets |
  | TF_VAR_vnet_cidr                       | 10.172.0.0/16    | CIDR block for the VNet                     |
  | TF_VAR_disable_bgp_route_propagation   | false            | Disable BGP route propagation flag          |


## Worflow Outputs


  | Name                        | Description                                                            |
  | --------------------------- | ---------------------------------------------------------------------- |
  | vnet_name                   | Name of the virtual network                                            |
  | location                    | Location of the resources                                              |
  | resource_group_name         | Name of the resource group                                             |
  | vnet_id                     | ID of the virtual network                                              |
  | vnet_cidr                   | CIDR block for the virtual network                                     |
  | outside_subnet_ids          | IDs of the subnets outside the virtual network                         |
  | inside_subnet_ids           | IDs of the subnets inside the virtual network                          |
  | local_subnet_ids            | IDs of the local subnets                                               |
  | outside_subnet_names        | Names of the subnets outside the virtual network                       |
  | inside_subnet_names         | Names of the subnets inside the virtual network                        |
  | local_subnet_names          | Names of the local subnets                                             |
  | inside_route_table_ids      | IDs of the route tables for the subnets inside the virtual network     |
  | inside_route_table_names    | Names of the route tables for the subnets inside the virtual network   |
  | outside_security_group_name | Name of the security group for the subnets outside the virtual network |
  | inside_security_group_name  | Name of the security group for the subnets inside the virtual network  |
  | az_names                    | Names of the availability zones                                        |


## Workflow Runs

**STEP 1:** Open GitHub Actions and select the "Azure Networking Apply" workflow. Fill required parameters, click "Run Workflow" and select the branch you want to run the workflow on.

  **DEPLOY**
  
  | Workflow                         | Name                           |
  | -------------------------------- | ------------------------------ |
  | azure-networking-apply.yaml      | Azure Networking Apply         |
 
  **DESTROY**
  
  | Workflow                           | Name                             |
  | ---------------------------------- | -------------------------------- |
  | azure-networking-destroy.yaml      | Azure Networking Destroy         |