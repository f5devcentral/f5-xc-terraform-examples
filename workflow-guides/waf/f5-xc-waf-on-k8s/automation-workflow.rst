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

   -  Please make sure resources like VPC and Elastic IP’s are below the
      threshold limit in that aws region

-  `Terraform Cloud
   Account <https://developer.hashicorp.com/terraform/tutorials/cloud-get-started>`__
-  `GitHub Account <https://github.com>`__

Workflow
-----------------

-  For deploying WAF on k8s, please copy the `waf-k8s-apply.yml <.github/workflows/waf-k8s-apply.yml>`__ to root folder .github/workflows folder.
-  Login to Distributed Cloud, click on `Multi-Cloud-Connect`, navigate to `Site Management` and then to `Site Tokens` as shown below
.. image:: /workflow-guides/waf/f5-xc-waf-on-k8s/assets/site-token.jpg
-  Create a site token with your CE site name and copy the ID


List of Products Used
-----------------------

-  **xc:** F5 Distributed Cloud WAF
-  **infra:** AWS Infrastructure (VPC, IGW, etc.)
-  **eks:** AWS Elastic Kubernetes Service
-  **bookinfo:** Bookinfo test web application and API


Tools
-----

-  **Cloud Provider:** AWS
-  **IAC:** Terraform
-  **IAC State:** Terraform Cloud
-  **CI/CD:** GitHub Actions

Terraform Cloud
---------------

-  **Workspaces:** Create a CLI or API workspace for each asset in the
   workflow chosen as shown below.
.. image:: /workflow-guides/waf/f5-xc-waf-on-k8s/assets/cloud-workspaces.JPG 

-  Login to terraform cloud and create below workspaces for storing the terraform state file of each job.
 infra, xc, eks, bookinfo, registration, k8sce


-  **Workspace Sharing:** Under the settings for each Workspace, set the
   **Remote state sharing** to share with each Workspace created.

-  **Variable Set:** Create a Variable Set with the following values:

   +------------------------+--------------+------------------------------------------------------+
   |         **Name**       |  **Type**    |      **Description**                                 |
   +========================+==============+======================================================+
   | AWS_ACCESS_KEY_ID      | Environment  | Your AWS Access Key ID                               |
   +------------------------+--------------+------------------------------------------------------+
   | AWS_SECRET_ACCESS_KEY  | Environment  | Your AWS Secret Access Key                           |
   +------------------------+--------------+------------------------------------------------------+
   | AWS_SESSION_TOKEN      | Environment  | Your AWS Session Token                               | 
   +------------------------+--------------+------------------------------------------------------+
   | VOLT_API_P12_FILE      | Environment  |  Your F5XC API certificate. Set this to **api.p12**  |
   +------------------------+--------------+------------------------------------------------------+
   | VES_P12_PASSWORD       | Environment  |  Set this to the password you supplied               |
   +------------------------+--------------+------------------------------------------------------+
   | ssh_key                | TERRAFORM    |  Your ssh key for accessing the created resources    | 
   +------------------------+--------------+------------------------------------------------------+
   | tf_cloud_organization  | TERRAFORM    |  Your Terraform Cloud Organization name              |
   +------------------------+--------------+------------------------------------------------------+

-  Check below image for more info on variable sets
.. image:: /workflow-guides/waf/f5-xc-waf-on-k8s/assets/variables-set.JPG


GitHub
------

-  Fork and Clone Repo. Navigate to ``Actions`` tab and enable it.

-  **Actions Secrets:** Create the following GitHub Actions secrets in
   your forked repo

   -  P12: The linux base64 encoded F5XC P12 certificate
   -  TF_API_TOKEN: Your Terraform Cloud API token
   -  TF_CLOUD_ORGANIZATION: Your Terraform Cloud Organization name
   -  TF_CE_LATITUDE: Your CE location latitude
   -  TF_CE_LONGITUDE: Your CE location longitude
   -  TF_CE_TOKEN: CE token ID generated in Distributed Cloud
   -  TF_VAR_SITE_NAME: CE site name to be registered
   -  TF_CLOUD_WORKSPACE\_\ *<Workspace Name>*: Create for each
      workspace in your workflow per each job

      -  EX: TF_CLOUD_WORKSPACE_EKS would be created with the
         value ``EKS``

-  Check below image for more info on action secrets
.. image:: /workflow-guides/waf/f5-xc-waf-on-k8s/assets/actions-secrets.JPG

Workflow Runs
-------------

**STEP 1:** Check out a branch with the branch name as suggested below for the workflow you wish to run using
the following naming convention.

**DEPLOY**

================ =======================
Workflow         Branch Name
================ =======================
f5-xc-waf-on-k8s deploy-waf-k8s
================ =======================

**DESTROY**

================ ========================
Workflow         Branch Name
================ ========================
f5-xc-waf-on-k8s destroy-waf-k8s
================ ========================

**STEP 2:** Rename ``infra/terraform.tfvars.examples`` to ``infra/terraform.tfvars`` and add the following data: 

-  project_prefix = “Your project identifier name in **lower case** letters only - this will be applied as a prefix to all assets”

-  resource_owner = “Your-name” 

-  aws_region = “AWS Region” ex. us-east-1 

-  azs = [“us-east-1a”, “us-east1b”] - Change to Correct Availability Zones based on selected Region 

-  Also update assets boolean value as per your work-flow

**Step 3:** Rename ``xc/terraform.tfvars.examples`` to ``xc/terraform.tfvars`` and add the following data: 

-  api_url = “Your F5XC tenant” 

-  xc_tenant = “Your tenant id available in F5 XC ``Administration`` section ``Tenant Overview`` menu” 

-  xc_namespace = “The existing XC namespace where you want to deploy resources” 

-  app_domain = “the FQDN of your app (cert will be autogenerated)” 

-  xc_waf_blocking = “Set to true to enable blocking”

-  k8s_pool = "true if backend is residing in k8s"

-  serviceName = "k8s service name of backend"

-  serviceport = "k8s service port of backend"

-  advertise_sites = "set to false if want to advertise on public"

-  http_only = "set to true if want to advertise on http protocol"

**STEP 4:** Commit and push your build branch to your forked repo \*
Build will run and can be monitored in the GitHub Actions tab and TF
Cloud console

**STEP 5:** Once the pipeline completes, verify your CE, Origin Pool and LB were deployed or destroyed based on your workflow.

**STEP 6:** You can login to AWS console, copy the load balancer DNS and send request with XC LB as a Host header which should provide the application response as shown below

.. image:: /workflow-guides/waf/f5-xc-waf-on-k8s/assets/postman.JPG
