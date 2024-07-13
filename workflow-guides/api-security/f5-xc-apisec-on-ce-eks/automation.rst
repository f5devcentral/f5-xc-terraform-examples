F5 Distributed Cloud API Security CICD Deployment
==================================================

Prerequisites
--------------

-  `F5 Distributed Cloud Account
   (F5XC) <https://console.ves.volterra.io/signup/usage_plan>`__

   -  `F5XC API
      certificate <https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials>`__
   -  `User Domain
      delegated <https://docs.cloud.f5.com/docs/how-to/app-networking/domain-delegation>`__

-  `AWS Account <https://aws.amazon.com>`__ 
   - Due to the assets being created, free tier will not work.
   - Please make sure resources like VPC and Elastic IP’s are below the threshold limit in that aws region.

-  `Terraform Cloud
   Account <https://developer.hashicorp.com/terraform/tutorials/cloud-get-started>`__
-  `GitHub Account <https://github.com>`__

Workflow Steps
--------------

- Login to Distributed Cloud, Select `Multi-Cloud Network Connect` service , navigate to `Manage -> Site Management` and then choose `Site Tokens` from the drop-down.

.. image:: /workflow-guides/waf/f5-xc-waf-on-k8s/assets/site-token.jpg

- Add a site token and copy the token ID


List of Products Used
---------------------

-  **xc:** F5 Distributed Cloud WAAP
-  **infra:** AWS Infrastructure (VPC, IGW, etc.)
-  **eks:** AWS Elastic Kubernetes Service
-  **crapi:** vulnerable application


Tools
------

-  **Cloud Provider:** AWS
-  **IAC:** Terraform
-  **IAC State:** Terraform Cloud
-  **CI/CD:** GitHub Actions

Terraform Cloud
----------------

-  **Workspaces:** Login to terraform cloud and create below CLI or API driven workspaces for storing the terraform state of each job.

   +-----------------+------------------------------------------------+
   | **Workflow**    |  **Workspaces**                                |
   +=================+================================================+
   | api-ce-eks      | infra, eks, crapi, ce, xc                      | 
   +-----------------+------------------------------------------------+

-  **Workspace Sharing:** Under the settings for each Workspace, set the **Remote state sharing** to share with each Workspace created.

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
   | VOLT_API_P12_FILE      | Environment  | Your F5XC API certificate. Set this to **api.p12**   |
   +------------------------+--------------+------------------------------------------------------+
   | VES_P12_PASSWORD       | Environment  | Set this to the password you supplied                |
   +------------------------+--------------+------------------------------------------------------+
   | ssh_key                | TERRAFORM    | Your ssh key for accessing the created resources     | 
   +------------------------+--------------+------------------------------------------------------+
   | tf_cloud_organization  | TERRAFORM    | Your Terraform Cloud Organization name               |
   +------------------------+--------------+------------------------------------------------------+



GitHub
-------

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

      -  Ex: TF_CLOUD_WORKSPACE_EKS would be created with the value ``eks``
             TF_CLOUD_WORKSPACE_CRAPI would be created with the value ``crapi``
-  Check below image for more info on action secrets

.. image:: /workflow-guides/api-security/f5-xc-apisec-on-ce-eks/assets/actions-secrets.JPG

Workflow Runs
--------------

**STEP 1:** Check out a branch with the branch name as suggested below for the workflow you wish to run using the following naming convention.

**DEPLOY**

+---------------------+--------------------+
| Workflow            |  Branch Name       |
+=====================+====================+
| f5-xc-api-on-ce-eks | deploy-api-ce-eks  |
+---------------------+--------------------+

**DESTROY**

+---------------------+--------------------+
| Workflow            |  Branch Name       |
+=====================+====================+
| f5-xc-api-on-ce-eks | destroy-api-ce-eks |
+---------------------+--------------------+

**Note:** Make sure to comment line no. 16 (# *.tfvars) in ".gitignore" file

**STEP 2:** Rename ``aws/infra/terraform.tfvars.examples`` to ``aws/infra/terraform.tfvars`` and add the following data: 

-  project_prefix = “Your project identifier name in **lower case** letters only - this will be applied as a prefix to all assets”

-  resource_owner = “Your-name” 

-  aws_region = “AWS Region” ex. us-east-1 

-  azs = [“us-east-1a”, “us-east1b”] - Change to Correct Availability Zones based on selected Region 

-  Also update assets boolean value as per your work-flow, for this use-case set all other values as false.

**Step 3:** Rename ``aws/eks-cluster/terraform.tfvars.examples`` to ``aws/eks-cluster/terraform.tfvars`` and add the following data:

- Set skip_ha_az_node_group = true

- Set desired_size = 2 (desired number of node count)

- Set max_size = 2 (max. number of node count)

- Set min_size= 2 (min. number of node count)

- Set skip_private_subnet_creation = false

- Set allow_all_ingress_traffic_to_cluster = true

- Let aws_waf_ce = "" 

**Step 4:** Rename ``xc/terraform.tfvars.examples`` to ``xc/terraform.tfvars`` and add the following data: 

-  api_url = “Your F5XC tenant url” 

-  xc_tenant = “Your tenant id available in F5 XC ``Administration`` section ``Tenant Overview`` menu” 

-  xc_namespace = “The existing XC namespace where you want to deploy resources” 

-  app_domain = “the FQDN of your app (cert will be autogenerated)” 

-  xc_waf_blocking = "true"

-  k8s_pool = "true"

-  serviceName = "crapi-web.crapi"

-  serviceport = "80"

-  xc_api_disc = true

-  xc_api_pro  = true

-  xc_api_spec = ["path to your OAS in XC"] **note** Import OpenAPI Specification Files to XC console following `doc <https://docs.cloud.f5.com/docs/how-to/advanced-security/import-openapi-spec>`__ view JSON after completion of Step 3 in the doc to know the path.

-  xc_api_val = true

-  xc_api_val_all   = true

-  xc_api_val_properties = ["PROPERTY_QUERY_PARAMETERS", "PROPERTY_PATH_PARAMETERS", "PROPERTY_CONTENT_TYPE", "PROPERTY_COOKIE_PARAMETERS", "PROPERTY_HTTP_HEADERS", "PROPERTY_HTTP_BODY"]

-  xc_api_val_active = true

-  enforcement_block  = false

-  enforcement_report = true

-  fall_through_mode_allow = false

-  xc_api_val_custom = false 

-  site_name = your CE site name

-  eks_ce_site = "true"

-  user_site = "true"

Keep rest of the values in terraform.tfvars as it is.

**STEP 5:** Commit and push your build branch to your forked repo, Build will run and can be monitored in the GitHub Actions tab and TF Cloud console

**STEP 6:** Once the pipeline completes, verify your CE, Origin Pool and LB were deployed or destroyed based on your workflow.

**STEP 7:** If you want to destroy the entire setup, checkout/create a new branch from ``deploy-api-ce-eks`` branch with name ``destroy-api-ce-eks`` which will trigger destroy work-flow to remove all resources
