# F5 Distributed Cloud AWS Cloud Credentials

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
  | aws-cloud-credentials-apply | aws-cloud-credentials  |
  
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
  | XC_AWS_ACCESS_KEY                  | false        | AWS access key for F5XC if you want to use different key for XC Credentials |
  | XC_AWS_SECRET_KEY                  | false        | AWS secret key for F5XC if you want to use different key for XC Credentials |
  | XC_AWS_CLOUD_CREDENTIALS_NAME      | false        | Name of the F5 XC API certificate to use instead of creating a new one      |

* **Actions Environemnt:** Optionally create the following GitHub Actions environments in your forked repo


  | **Name**                           | **Default**            | **Description**                           |
  | ---------------------------------- | ---------------------- | ----------------------------------------- |
  | TF_VAR_name                        | aws-cloud-credentials  | Name for the resources                    |
  | TF_VAR_prefix                      |                        | Prefix for the resources                  |
  | TF_CLOUD_WORKSPACE_AWS_CREDENTIALS | aws-cloud-credentials  | Name of the Terraform Cloud workspace     |


## Worflow Outputs

  | **Name**                  | **Description**                        |
  | ------------------------- | -------------------------------------- |
  | aws_credentials_name      | Name of the AWS Cloud Credentials      |
  | aws_credentials_namespace | Namespace of the AWS Cloud Credentials |

## Workflow Runs

**STEP 1:** Open GitHub Actions and select the "AWS XC Cloud Credentials Apply" workflow. Click "Run Workflow" and select the branch you want to run the workflow on.


  **DEPLOY**
  
  | Workflow                         | Name                           |
  | -------------------------------- | ------------------------------ |
  | aws-cloud-credentials-apply.yaml | AWS XC Cloud Credentials Apply |
 
  **DESTROY**
  
  | Workflow                           | Name                             |
  | ---------------------------------- | -------------------------------- |
  | aws-cloud-credentials-destroy.yaml | AWS XC Cloud Credentials Destroy |