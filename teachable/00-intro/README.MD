# Teachable - 00-intro Course

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

* **Organization:** Create a new Organization for the Teachable project(s). 

* **Settings**: Under **Settings** select the **General** tab (under **Organization Settings**) and for **Default Execution Mode** select "Local". Under **Security** section select **API Tokens** and create a new Organization Token for your created Organization. You will need this later in the GitHub Actions section.

* **Workspaces:** The following workspaces will be created in Terraform Cloud unless otherwise specified in the Actions Environments.


  | **Workflow**                  | **Assets/Workspaces**    |
  | ------------------------------| ------------------------ |
  | teachable-00-intro-apply      | hello-world              |
  | teachable-00-intro-apply      | xc-credentials           |
  | aws-cloud-credentials-apply   | aws-cloud-credentials    |
  | azure-cloud-credentials-apply | azure-cloud-credentials  |

## AWS

**STEP 1:** Log in to your AWS Management Console:
- Navigate to AWS Management Console.
- Enter your credentials to log in.

**STEP 2:** Access the IAM Dashboard:
- Once logged in, find the **Services** menu at the top of the console.
- Click on **Services** and select **IAM** under the **Security, Identity, & Compliance** section.

**STEP 3:** Navigate to Users:
- In the IAM dashboard, click on **Users** in the left navigation pane.
- This will display a list of IAM users associated with your AWS account.

**STEP 4:** Select or Create a User:
- If you’re creating a new key for an existing user, click on the user’s name.
- If this option is not available, you will need to contact your AWS account administrator to create a new user with programmatic access.

**STEP 5:** Access the Security Credentials Tab:
- Once you've selected or created a user, go to the “Security credentials” tab.

**STEP 6:** Create Access Key:
- In the “Security credentials” tab, find the “Access keys” section.
- Click on “Create access key”.
- A new Access Key ID and Secret Access Key will be generated.
- Download or Save the Credentials.


## Azure

**STEP 1:** Open Azure Cloud Shell:
- Navigate to the Azure Portal (https://portal.azure.com).
- Open the Azure Cloud Shell by clicking on the Cloud Shell icon (resembling a command prompt) at the top-right corner of the Azure Portal.

**STEP 2:** Choose the Shell Environment:
- If prompted, choose either Bash or PowerShell as your shell environment. This command works in both environments.

**STEP 3:** Set Azure Subscription (Optional):
- If you are working with multiple subscriptions, set your desired subscription using:
  
```bash
az account list --output table

# find the subscription you want to use and replace {AZURE_SUBSCRIPTION_ID} with your actual Azure Subscription ID

az account set --subscription "{AZURE_SUBSCRIPTION_ID}"
```

**STEP 4:** Execute the Service Principal Creation Command:
- Run the following command:
  
```bash
az ad sp create-for-rbac --role contributor --scopes "/subscriptions/{AZURE_SUBSCRIPTION_ID}" --name "teachable"
```
**Ensure you replace {AZURE_SUBSCRIPTION_ID} with your actual Azure Subscription ID.**
This command will create a new Service Principal named "teachable" with Contributor role scoped to the specified subscription.

**STEP 5:** Record the Service Principal Information:

The output will include important information such as `appId (client_id)`, displayName, `password (client_secret)`, and `tenant (tenantid)`.
Securely store this information as it will be needed for authentication and authorization purposes.

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


* **Actions Environment:** Create the following GitHub Actions environments in your forked repo if you want to override the defaults.


  | **Name**                             | **Default**             | **Description**                                                              |
  | ------------------------------------ | ----------------------- | ---------------------------------------------------------------------------- |
  | TF_VAR_name                          | teachable               | Name for the resources                                                       |
  | TF_VAR_prefix                        | null                    | Prefix for the resources                                                     |
  | TF_CLOUD_WORKSPACE_HELLO_WORLD       | hello-world             | Name of the Terraform Cloud workspace                                        |
  | TF_CLOUD_WORKSPACE_XC_CREDENTIALS    | xc-credentials          | Name of the Terraform Cloud workspace                                        |
  | TF_CLOUD_WORKSPACE_AWS_CREDENTIALS   | aws-cloud-credentials   | Name of the Terraform Cloud workspace                                        |
  | TF_CLOUD_WORKSPACE_AZURE_CREDENTIALS | azure-cloud-credentials | Name of the Terraform Cloud workspace                                        |
  | AWS_CLOUD_CREDENTIALS_TF_VAR_name    | aws-cloud-credentials   | Name that will be passed to the AWS "aws-cloud-credentials-apply" workflow   |
  | AZURE_CLOUD_CREDENTIALS_TF_VAR_name  | azure-cloud-credentials | Name that will be passed to the AWS "azure-cloud-credentials-apply" workflow |

## Workflow Runs

**STEP 1:** Open GitHub Actions and select the `Teachable 00-intro Apply` workflow. 

**STEP 2:** Select Lesson from the list from the dropdown menu.

  **LESSONS**
  
  | **Lesson**        | **Description**                  |
  | ----------------- | -------------------------------- |
  | terraform-cloud   | Hello World into Terraform Cloud |
  | xc-credentials    | XC Credentials                   |
  | azure-credentials | AWS Credentials                  |
  | aws-credentials   | Azure Credentials                |

**STEP 3:** Optionally update `Deployment name` and `Prefix`.

**STEP 4:** Click `Run Workflow` 

**STEP 5:** Repeat steps 1-4 for each lesson.

**STEP 6:** Run the `Teachable 00-intro Destroy` workflow to destroy all resources created by the `Teachable 00-intro Apply` workflow.
