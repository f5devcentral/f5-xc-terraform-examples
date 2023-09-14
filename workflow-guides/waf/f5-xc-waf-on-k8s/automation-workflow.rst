Getting Started With Terraform Automation
---------------

Prerequisites
-------------

-  `F5 Distributed Cloud Account
   (F5XC) <https://console.ves.volterra.io/signup/usage_plan>`__

   -  `F5XC API
      certificate <https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials>`__
   -  `User Domain
      delegated <https://docs.cloud.f5.com/docs/how-to/app-networking/domain-delegation>`__

-  `AWS Account <https://aws.amazon.com>`__ - Due to the assets being
   created, free tier will not work.

   -  The F5 BIG-IP AMI being used from the `AWS
      Marketplace <https://aws.amazon.com/marketplace>`__ must be
      subscribed to your account
   -  Please make sure resources like VPC and Elastic IP’s are below the
      threshold limit in that aws region

-  `Terraform Cloud
   Account <https://developer.hashicorp.com/terraform/tutorials/cloud-get-started>`__
-  `GitHub Account <https://github.com>`__

Selected Workflow
-----------------

Example: f5-xc-waf-on-re

Check the Automation section in your workflow guide for more details.

List of Existing Assets
-----------------------

-  **xc:** F5 Distributed Cloud WAAP
-  **infra:** AWS Infrastructure (VPC, IGW, etc.)
-  **eks:** AWS Elastic Kubernetes Service
-  **arcadia:** Arcadia Finance test web application and API
-  **juiceshop:** OWASP Juice Shop test web application

Tools
-----

-  **Cloud Provider:** AWS
-  **IAC:** Terraform
-  **IAC State:** Terraform Cloud
-  **CI/CD:** GitHub Actions

Terraform Cloud
---------------

-  **Workspaces:** Create a CLI or API workspace for each asset in the
   workflow chosen. Check the Automation section in your workflow guide
   for more details

Example:

=============== =====================
**Workflow**    **Assets/Workspaces**
=============== =====================
f5-xc-waf-on-re infra, xc
=============== =====================

-  **Workspace Sharing:** Under the settings for each Workspace, set the
   **Remote state sharing** to share with each Workspace created.

-  **Variable Set:** Create a Variable Set with the following values:

   +------------+------+--------------------------------------------------+
   | **Name**   | **Ty | **Description**                                  |
   |            | pe** |                                                  |
   +============+======+==================================================+
   | AWS_ACC    | Env  | Your AWS Access Key ID                           |
   | ESS_KEY_ID | iron |                                                  |
   |            | ment |                                                  |
   +------------+------+--------------------------------------------------+
   | A          | Env  | Your AWS Secret Access Key                       |
   | WS_SECRET_ | iron |                                                  |
   | ACCESS_KEY | ment |                                                  |
   +------------+------+--------------------------------------------------+
   | AWS_SES    | Env  | Your AWS Session Token                           |
   | SION_TOKEN | iron |                                                  |
   |            | ment |                                                  |
   +------------+------+--------------------------------------------------+
   | VOLT_AP    | Env  | Your F5XC API certificate. Set this to           |
   | I_P12_FILE | iron | **api.p12**                                      |
   |            | ment |                                                  |
   +------------+------+--------------------------------------------------+
   | VES_P1     | Env  | Set this to the password you supplied when       |
   | 2_PASSWORD | iron | creating your F5 XC API certificate              |
   |            | ment |                                                  |
   +------------+------+--------------------------------------------------+
   | ssh_key    | T    | Your ssh key for accessing the created BIG-IP    |
   |            | erra | and compute assets                               |
   |            | form |                                                  |
   +------------+------+--------------------------------------------------+
   | admi       | T    | The source address and subnet in CIDR format of  |
   | n_src_addr | erra | your administrative workstation                  |
   |            | form |                                                  |
   +------------+------+--------------------------------------------------+
   | t          | T    | Your Terraform Cloud Organization name           |
   | f_cloud_or | erra |                                                  |
   | ganization | form |                                                  |
   +------------+------+--------------------------------------------------+

GitHub
------

-  **Fork and Clone Repo. Navigate to ``Actions`` tab and enable it.**

-  **Actions Secrets:** Create the following GitHub Actions secrets in
   your forked repo

   -  P12: The linux base64 encoded F5XC API certificate
   -  TF_API_TOKEN: Your Terraform Cloud API token
   -  TF_CLOUD_ORGANIZATION: Your Terraform Cloud Organization name
   -  TF_CLOUD_WORKSPACE\_\ *<Workspace Name>*: Create for each
      workspace in your workflow

      -  EX: TF_CLOUD_WORKSPACE_BIGIP_BASE would be created with the
         value ``bigip-base``

Workflow Runs
-------------

**STEP 1:** Check out a branch for the workflow you wish to run using
the following naming convention.

**DEPLOY**

================ =======================
Workflow         Branch Name
================ =======================
f5-xc-waf-on-k8s deploy-f5-xc-waf-on-k8s
f5-xc-waf-on-re  deploy-f5-xc-waf-on-re
================ =======================

**DESTROY**

================ ========================
Workflow         Branch Name
================ ========================
f5-xc-waf-on-k8s destroy-f5-xc-waf-on-k8s
f5-xc-waf-on-re  destroy-f5-xc-waf-on-re
================ ========================

**STEP 2:** Rename ``infra/terraform.tfvars.examples`` to
``infra/terraform.tfvars`` and add the following data: \* project_prefix
= “Your project identifier name in **lower case** letters only - this
will be applied as a prefix to all assets” \* resource_owner =
“Your-name” \* aws_region = “AWS Region” ex. us-east-1 \* azs =
[“us-east-1a”, “us-east1b”] - Change to Correct Availability Zones based
on selected Region \* Also update assets boolean value as per your
work-flow

**Step 3:** Rename ``xc/terraform.tfvars.examples`` to
``xc/terraform.tfvars`` and add the following data: \* api_url = “Your
F5XC tenant” \* xc_tenant = “Your tenant id available in F5 XC
``Administration`` section ``Tenant Overview`` menu” \* xc_namespace =
“The existing XC namespace where you want to deploy resources” \*
app_domain = “the FQDN of your app (cert will be autogenerated)” \*
xc_waf_blocking = “Set to true to enable blocking”

**STEP 4:** Commit and push your build branch to your forked repo \*
Build will run and can be monitored in the GitHub Actions tab and TF
Cloud console

| **STEP 5:** Once the pipeline completes, verify your assets were
  deployed or destroyed based on your workflow.
| **NOTE:** The autocert process takes time. It may be 5 to 10 minutes
  before Let’s Encrypt has provided the cert.
