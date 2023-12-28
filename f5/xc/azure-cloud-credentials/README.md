# F5 Distributed Cloud Azure Cloud Credentials

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


  | **Workflow**                  | **Assets/Workspaces**  |
  | ------------------------------| ---------------------- |
  | azure-cloud-credentials-apply | azure-cloud-credentials  |
  
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
  | XC_AZURE_SUBSCRIPTION_ID           | false        | Azure subscription ID for F5XC (if different from AZURE_SUBSCRIPTION_ID)    |
  | XC_AZURE_TENANT_ID                 | false        | Azure tenant ID for F5XC (if different from AZURE_TENANT_ID)                |
  | XC_AZURE_CLIENT_ID                 | false        | Azure client ID for F5XC (if different from AZURE_CLIENT_ID)                |
  | XC_AZURE_CLIENT_SECRET             | false        | Azure client secret for F5XC (if different from AZURE_CLIENT_SECRET)        |
  | AZURE_CLOUD_CREDENTIALS_NAME       | false        | Name of the F5 XC Cloud Credentilas to use instead of creating a new one    |

* **Actions Environemnt:** Optionally create the following GitHub Actions environments in your forked repo


  | **Name**                           | **Default**             | **Description**                           |
  | ---------------------------------- | ----------------------- | ----------------------------------------- |
  | TF_VAR_name                        | azure-cloud-credentials | Name for the resources                    |
  | TF_VAR_prefix                      | null                    | Prefix for the resources                  |
  | TF_CLOUD_WORKSPACE_AWS_CREDENTIALS | azure-cloud-credentials | Name of the Terraform Cloud workspace     |


## Worflow Outputs

  | **Name**                    | **Description**                          |
  | --------------------------- | ---------------------------------------- |
  | azure_credentials_name      | Name of the Azure Cloud Credentials      |
  | azure_credentials_namespace | Namespace of the Azure Cloud Credentials |

## Workflow Runs

**STEP 1:** Open GitHub Actions and select the "Azure XC Cloud Credentials Apply" workflow. Click "Run Workflow" and select the branch you want to run the workflow on.

  **DEPLOY**
  
  | Workflow                           | Name                             |
  | ---------------------------------- | -------------------------------- |
  | azure-cloud-credentials-apply.yaml | Azure XC Cloud Credentials Apply |
 
  **DESTROY**
  
  | Workflow                             | Name                               |
  | ------------------------------------ | ---------------------------------- |
  | azure-cloud-credentials-destroy.yaml | Azure XC Cloud Credentials Destroy |