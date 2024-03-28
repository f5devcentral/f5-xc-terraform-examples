# F5 Distributed Cloud Terraform Examples

## Overview

Examples of F5 Distributed Cloud (XC) deployments utilizing Terraform. For more information on the use cases covered by this project, please see the following articles and workflow guides:


* **F5 Distributed Cloud WAF**

  | **DevCentral Overview Articles**                                                                                                                          | **Use Case / Workflow Guides (SaaS Console, Automation)**                                                                                                                                                |
  | --------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
  | [Deploy WAF on any Edge with F5 Distributed Cloud](https://community.f5.com/t5/technical-articles/deploy-waf-on-any-edge-with-f5-distributed-cloud/ta-p/313079) | [Deploy F5 XC WAF on XC Regional Edges (SaaS Console, Automation)](https://github.com/f5devcentral/f5-xc-waap-terraform-examples/blob/main/workflow-guides/waf/f5-xc-waf-on-re/README.rst)                         |
  | [Deploy WAF on any Edge with F5 Distributed Cloud](https://community.f5.com/t5/technical-articles/deploy-waf-on-any-edge-with-f5-distributed-cloud/ta-p/313079) | [Deploy F5 XC WAF on XC Regional Edges + AppConnect in VM (SaaS Console, Automation)](https://github.com/f5devcentral/f5-xc-waap-terraform-examples/blob/main/workflow-guides/waf/f5-xc-waf-on-re-appconnect/vm/README.rst) |
  | [Deploy WAF on any Edge with F5 Distributed Cloud](https://community.f5.com/t5/technical-articles/deploy-waf-on-any-edge-with-f5-distributed-cloud/ta-p/313079) | [Deploy F5 XC WAF on XC Regional Edges + AppConnect in K8s (SaaS Console, Automation)](https://github.com/f5devcentral/f5-xc-waap-terraform-examples/blob/main/workflow-guides/waf/f5-xc-waf-on-re-appconnect/k8s/README.rst) |
  | [Deploy WAF on any Edge with F5 Distributed Cloud](https://community.f5.com/t5/technical-articles/deploy-waf-on-any-edge-with-f5-distributed-cloud/ta-p/313079) | [Deploy F5 XC WAF on XC Customer Edge in AWS (SaaS Console, Automation)](https://github.com/f5devcentral/f5-xc-waap-terraform-examples/blob/main/workflow-guides/waf/f5-xc-waf-on-ce/aws/README.rst)                            |
  | [Deploy WAF on any Edge with F5 Distributed Cloud](https://community.f5.com/t5/technical-articles/deploy-waf-on-any-edge-with-f5-distributed-cloud/ta-p/313079) | [Deploy F5 XC WAF on XC Customer Edge in Azure (SaaS Console, Automation)](https://github.com/f5devcentral/f5-xc-waap-terraform-examples/blob/main/workflow-guides/waf/f5-xc-waf-on-ce/azure/README.rst)                            |
  | [Deploy WAF on any Edge with F5 Distributed Cloud](https://community.f5.com/t5/technical-articles/deploy-waf-on-any-edge-with-f5-distributed-cloud/ta-p/313079) | [Deploy F5 XC WAF on XC Customer Edge in GCP (SaaS Console, Automation)](https://github.com/f5devcentral/f5-xc-waap-terraform-examples/blob/main/workflow-guides/waf/f5-xc-waf-on-ce/gcp/README.rst)                            |
  | [Deploy WAF on any Edge with F5 Distributed Cloud](https://community.f5.com/t5/technical-articles/deploy-waf-on-any-edge-with-f5-distributed-cloud/ta-p/313079) | [Deploy F5 XC WAF on XC Customer Edges + MultiCloud](https://github.com/f5devcentral/f5-xc-waap-terraform-examples/blob/main/workflow-guides/waf/f5-xc-waf-on-ce-multicloud/README.rst) |
  | [Deploy WAF on any Edge with F5 Distributed Cloud](https://community.f5.com/t5/technical-articles/deploy-waf-on-any-edge-with-f5-distributed-cloud/ta-p/313079) | [Deploy F5 XC WAF on Kubernetes (SaaS Console, Automation)](https://github.com/f5devcentral/f5-xc-waap-terraform-examples/blob/main/workflow-guides/waf/f5-xc-waf-on-k8s/README.rst)       |


* **F5 Distributed Cloud API Security**
  
  | **DevCentral Overview Articles**                                                                                                                                                     | **Use Case / Workflow Guides (SaaS Console, Automation)**                                                                                                                                                                    |
  | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
  | [Deploy API Security on Regional Edges with F5 Distributed Cloud](https://community.f5.com/t5/technical-articles/out-of-the-shadows-api-discovery-and-security/ta-p/303789)          | [Deploy F5 XC API Security on XC Regional Edges](https://github.com/f5devcentral/f5-xc-waap-terraform-examples/blob/main/workflow-guides/api-security/f5-xc-apisec-on-re/README.md)                                          |
  | [**Coming soon:**  Deploy API Security Anywhere with F5 Distributed Cloud](https://community.f5.com/t5/technical-articles/out-of-the-shadows-api-discovery-and-security/ta-p/303789) | [**Coming soon:** Deploy F5 XC API Security on XC Regional Edges + AppConnect](https://github.com/f5devcentral/f5-xc-waap-terraform-examples/blob/main/workflow-guides/api-security/f5-xc-apisec-on-re-appconnect/README.md) |
  | [**Coming soon:**  Deploy API Security Anywhere with F5 Distributed Cloud](https://community.f5.com/t5/technical-articles/out-of-the-shadows-api-discovery-and-security/ta-p/303789) | [**Coming soon:** Deploy F5 XC API Security on XC Customer Edges](https://github.com/f5devcentral/f5-xc-waap-terraform-examples/blob/main/workflow-guides/api-security/f5-xc-apisec-on-ce/README.md)                         |
  | [Deploy API Security Anywhere with F5 Distributed Cloud](https://community.f5.com/t5/technical-articles/out-of-the-shadows-api-discovery-and-security/ta-p/303789)                   | [Deploy F5 XC API Security on Kubernetes](https://github.com/f5devcentral/f5-xc-waap-terraform-examples/blob/main/workflow-guides/api-security/f5-xc-apisec-on-k8s/README.md)                                                |
    | [**Coming soon:** Protect multi-cloud GenAI applications with F5 Distributed Cloud]()                   | [Protect LLM applications against Model Denial of Service](https://github.com/f5devcentral/f5-xc-terraform-examples/blob/main/workflow-guides/api-security/f5-xc-apisec-llm-dos/README.rst)                                                |

* **F5 Distributed Cloud Bot Protection**
  
  | **DevCentral Overview Articles**                                                                                                                                                                           | **Use Case / Workflow Guides (SaaS Console, Automation)**                                                                                                                                                                                                        |
  | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
  | [Deploy Bot Defense as Code (IaC) or SaaS Console Anywhere](https://community.f5.com/t5/technical-articles/deploy-bot-defense-as-code-iac-or-saas-console-anywhere/ta-p/323272)              | [Deploy Bot Defense on Regional Edges with F5 Distributed Cloud](https://github.com/f5devcentral/f5-xc-waap-terraform-examples/tree/main/workflow-guides/bot/deploy-botdefense-against-automated-threats-on-regional-edges-with-f5xc)           |
  | [Deploy Bot Defense as Code (IaC) or SaaS Console Anywhere](https://community.f5.com/t5/technical-articles/deploy-bot-defense-as-code-iac-or-saas-console-anywhere/ta-p/323272)                       | [ Deploy F5 XC Bot Defense for AWS Cloudfront with F5 Distributed Cloud](https://github.com/f5devcentral/f5-xc-waap-terraform-examples/tree/main/workflow-guides/bot/deploy-botdefense-for-awscloudfront-distributions-with-f5-distributedcloud) |
  | [Deploy Bot Defense as Code (IaC) or SaaS Console Anywhere](https://community.f5.com/t5/technical-articles/deploy-bot-defense-as-code-iac-or-saas-console-anywhere/ta-p/323272) | [Deploy Bot Defense in Azure with BIG-IP Connector for F5 Distributed Cloud](https://github.com/f5devcentral/f5-xc-waap-terraform-examples/tree/main/workflow-guides/bot/deploy-botdefense-in-azure-with-f5xc-bigip-connector)                  |
  | [Deploy Bot Defense as Code (IaC) or SaaS Console Anywhere](https://community.f5.com/t5/technical-articles/deploy-bot-defense-as-code-iac-or-saas-console-anywhere/ta-p/323272)      | [Deploy Bot Defense in GCP Using BIG-IP Connector for F5 Distributed Cloud](https://github.com/f5devcentral/f5-xc-waap-terraform-examples/tree/main/workflow-guides/bot/deploy-botdefense-in-gcp-with-f5xc-bigip-connector)                     |



* **F5 Distributed Cloud DoS Protection**


* **F5 Distributed Cloud Secure Multi-Cloud Networking (MCN)**

  | **DevCentral Overview Articles**                                                                                                                                                                           | **Use Case / Workflow Guides (SaaS Console, Automation)**                                                                                                                                                                                                        |
    | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
  | [Deploy S-MCN On Any Edge Using F5 Distributed Cloud](https://community.f5.com/kb/technicalarticles/f5-distributed-cloud-secure-mcn-deploy-infra-connect--secure-apps-everywhere/328179) | N/A - Refer to DevCentral article with linked YouTube video |
  | [Deploy Distributed Cloud WAAP Security Easily Using Multiple CE's](https://community.f5.com/kb/TechnicalArticles/using-distributed-application-security-policies-in-secure-multicloud-networking-/328803) | [Deploy Distributed Cloud WAAP Security Easily Using Multiple CE's (Automation)](https://github.com/f5devcentral/f5-xc-terraform-examples/tree/main/workflow-guides/smcn/distributed-cloud-waap) |
  | [**Coming soon:** Deploy App To App Connectivity Seamlessly Using Distributed Cloud](https://community.f5.com/kb/TechnicalArticles/the-app-delivery-fabric-with-secure-multicloud-networking/328804) | [Deploy App To App Connectivity Seamlessly Using Distributed Cloud (Automation)](https://github.com/f5devcentral/f5-xc-terraform-examples/tree/main/workflow-guides/smcn/app-delivery-fabric) |
  

* **F5 Distributed Cloud Teachable** 


  | **Teachable Courses**                                                                                                                                                                           | **Use Case / Workflow Resources (Automation, SaaS Console)**                                                                                                                                                                                                        |
  | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
  | [**PRE-REQUISITE:** 00 - Intro Course (Introduction and Initial Automation Configuration)](https://trainingf5cloud.teachable.com/p/automation-examples)              | [00 - Initial Configuration for Teachable Courses GIT Repo](https://github.com/f5devcentral/f5-xc-terraform-examples/tree/main/teachable/00-intro) |
  | [01 - Multi-Cloud Networking Course (Network Connect)](https://trainingf5cloud.teachable.com/p/automation-examples-mcn-network-connect) | [01 - MCN Network Connect GIT Repo](https://github.com/f5devcentral/f5-xc-terraform-examples/tree/main/teachable/01-mcn-networkconnect)  |
  | [F5 Distributed Cloud Web Application Firewall (WAF) on Customer Edge](https://trainingf5cloud.teachable.com/courses/enrolled/2462111)          |  [Deploy F5 XC WAF on XC Customer Edge in Azure (SaaS Console, Automation)](https://github.com/f5devcentral/f5-xc-waap-terraform-examples/blob/main/workflow-guides/waf/f5-xc-waf-on-ce/azure/README.rst) |

  
## Getting Started

## Prerequisites

* [F5 Distributed Cloud Account (F5XC)](https://console.ves.volterra.io/signup/usage_plan)
  * [F5XC API certificate](https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials)
  * [User Domain delegated](https://docs.cloud.f5.com/docs/how-to/app-networking/domain-delegation)
* [AWS Account](https://aws.amazon.com) - Due to the assets being created, free tier will not work.
  * The F5 BIG-IP AMI being used from the [AWS Marketplace](https://aws.amazon.com/marketplace) must be subscribed to your account
  * Please make sure resources like VPC and Elastic IP's are below the threshold limit in that aws region
* [Terraform Cloud Account](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started)
* [GitHub Account](https://github.com)

## Selected Workflow

Example: f5-xc-waf-on-re

Check the Automation section in your workflow guide for more details.

## List of Existing Assets

* **xc:**        F5 Distributed Cloud WAAP
* **infra:**     AWS Infrastructure (VPC, IGW, etc.)
* **eks:**       AWS Elastic Kubernetes Service
* **arcadia:**   Arcadia Finance test web application and API
* **juiceshop:** OWASP Juice Shop test web application

## Tools

* **Cloud Provider:** AWS
* **IAC:** Terraform
* **IAC State:** Terraform Cloud
* **CI/CD:** GitHub Actions

## Terraform Cloud

* **Workspaces:** Create a CLI or API workspace for each asset in the workflow chosen. Check the Automation section in your workflow guide for more details

Example:

  | **Workflow**    | **Assets/Workspaces** |
  | --------------- | --------------------- |
  | f5-xc-waf-on-re | infra, xc             |



* **Workspace Sharing:** Under the settings for each Workspace, set the **Remote state sharing** to share with each Workspace created.

* **Variable Set:** Create a Variable Set with the following values:

  | **Name**              | **Type**    | **Description**                                                                 |
  | --------------------- | ----------- | ------------------------------------------------------------------------------- |
  | AWS_ACCESS_KEY_ID     | Environment | Your AWS Access Key ID                                                          |
  | AWS_SECRET_ACCESS_KEY | Environment | Your AWS Secret Access Key                                                      |
  | AWS_SESSION_TOKEN     | Environment | Your AWS Session Token                                                          |
  | VOLT_API_P12_FILE     | Environment | Your F5XC API certificate file name. Set this to **api.p12**                    |
  | VES_P12_PASSWORD      | Environment | Set this to the password you supplied when creating your F5 XC API certificate  |
  | ssh_key               | Terraform   | Your ssh key for accessing the created BIG-IP and compute assets                |
  | admin_src_addr        | Terraform   | The source address and subnet in CIDR format of your administrative workstation |
  | tf_cloud_organization | Terraform   | Your Terraform Cloud Organization name                                          |

## GitHub

* **Fork and Clone Repo. Navigate to `Actions` tab and enable it.**

* **Actions Secrets:** Create the following GitHub Actions secrets in your forked repo
  *  P12: The linux base64 encoded F5XC API certificate
  *  TF_API_TOKEN: Your Terraform Cloud API token
  *  TF_CLOUD_ORGANIZATION: Your Terraform Cloud Organization name
  *  TF_CLOUD_WORKSPACE_*\<Workspace Name\>*: Create for each workspace in your workflow
      * EX: TF_CLOUD_WORKSPACE_BIGIP_BASE would be created with the value `bigip-base`

## Workflow Runs

**STEP 1:** Check out a branch for the workflow you wish to run using the following naming convention.

  **DEPLOY**

  | Workflow         | Branch Name             |
  | ---------------- | ----------------------- |
  | f5-xc-waf-on-k8s | deploy-f5-xc-waf-on-k8s |
  | f5-xc-waf-on-re  | deploy-f5-xc-waf-on-re  |

  **DESTROY**

  | Workflow         | Branch Name              |
  | ---------------- | ------------------------ |
  | f5-xc-waf-on-k8s | destroy-f5-xc-waf-on-k8s |
  | f5-xc-waf-on-re  | destroy-f5-xc-waf-on-re  |

**STEP 2:** Rename `infra/terraform.tfvars.examples` to `infra/terraform.tfvars` and add the following data:
  * project_prefix  = "Your project identifier name in **lower case** letters only - this will be applied as a prefix to all assets"
  * resource_owner = "Your-name"
  * aws_region     = "AWS Region" ex. us-east-1
  * azs            = ["us-east-1a", "us-east1b"] - Change to Correct Availability Zones based on selected Region
  * Also update assets boolean value as per your work-flow


**Step 3:** Rename `xc/terraform.tfvars.examples` to `xc/terraform.tfvars` and add the following data:
  * api_url         = "Your F5XC tenant"
  * xc_tenant       = "Your tenant id available in F5 XC `Administration` section `Tenant Overview` menu"
  * xc_namespace    = "The existing XC namespace where you want to deploy resources"
  * app_domain      = "the FQDN of your app (cert will be autogenerated)"
  * xc_waf_blocking = "Set to true to enable blocking"


**STEP 4:** Commit and push your build branch to your forked repo
  * Build will run and can be monitored in the GitHub Actions tab and TF Cloud console


**STEP 5:** Once the pipeline completes, verify your assets were deployed or destroyed based on your workflow.  
            **NOTE:**  The autocert process takes time.  It may be 5 to 10 minutes before Let's Encrypt has provided the cert.


## Development

Outline any requirements to setup a development environment if someone would like to contribute.  You may also link to another file for this information.

## Support

For support, please open a GitHub issue.  Note, the code in this repository is community supported and is not supported by F5 Networks.  

## Community Code of Conduct

Please refer to the [F5 DevCentral Community Code of Conduct](code_of_conduct.md).

## License

[Apache License 2.0](LICENSE)

## Copyright

Copyright 2014-2020 F5 Networks Inc.

### F5 Networks Contributor License Agreement

Before you start contributing to any project sponsored by F5 Networks, Inc. (F5) on GitHub, you will need to sign a Contributor License Agreement (CLA).

If you are signing as an individual, we recommend that you talk to your employer (if applicable) before signing the CLA since some employment agreements may have restrictions on your contributions to other projects.
Otherwise by submitting a CLA you represent that you are legally entitled to grant the licenses recited therein.

If your employer has rights to intellectual property that you create, such as your contributions, you represent that you have received permission to make contributions on behalf of that employer, that your employer has waived such rights for your contributions, or that your employer has executed a separate CLA with F5.

If you are signing on behalf of a company, you represent that you are legally entitled to grant the license recited therein.
You represent further that each employee of the entity that submits contributions is authorized to submit such contributions on behalf of the entity pursuant to the CLA.
