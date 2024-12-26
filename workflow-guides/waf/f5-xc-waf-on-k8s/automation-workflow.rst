Getting Started With Terraform Automation
###########################################

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
-----------------

Create a token
-----------------------
- For deploying WAF on k8s, please copy both yml files in workflow folder to root folder .github/workflows folder. For ex: `waf-k8s-apply.yml <https://github.com/f5devcentral/f5-xc-terraform-examples/blob/main/.github/workflows/waf-k8s-apply.yml>`__

- Login to Distributed Cloud, click on `Multi-Cloud-Connect`, navigate to `Site Management` and then to `Site Tokens` as shown below

.. image:: /workflow-guides/waf/f5-xc-waf-on-k8s/assets/site-token.jpg

- Create a site token with CE site name and copy the ID & name. 
**NOTE: MAKE SURE TOKEN IS NEWLY CREATED OR EXISTING TOKEN NOT BEING USED BY OTHER CE SITES FROM REGISTRATIONS PAGE IN SITE MANAGEMENT DROP-DOWN**


List of Products Used
-----------------------

-  **xc:** F5 Distributed Cloud WAF
-  **infra:** AWS Infrastructure (VPC, IGW, etc.)
-  **eks:** AWS Elastic Kubernetes Service
-  **bookinfo:** Bookinfo test web application and API


Tools
------

-  **Cloud Provider:** AWS
-  **IAC:** Terraform
-  **IAC State:** Terraform Cloud
-  **CI/CD:** GitHub Actions

Terraform Cloud
----------------

-  **Workspaces:** Login to terraform cloud and create below workspaces for storing the terraform state file of each job.
     aws-infra, xc, eks, bookinfo and ce


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

-  Check below image for more info on variable sets

.. image:: /workflow-guides/waf/f5-xc-waf-on-k8s/assets/variables-set.JPG


GitHub
-------

-  Fork and Clone Repo. Navigate to ``Actions`` tab and enable it.

-  **Actions Secrets:** Create the following GitHub Actions secrets in
   your forked repo

   -  P12: The linux base64 encoded F5XC P12 certificate (For windows run ``base64 <file-name>``, copy output content into a file and remove spaces.)
   -  TF_API_TOKEN: Your Terraform Cloud API token
   -  TF_CLOUD_ORGANIZATION: Your Terraform Cloud Organization name
   -  TF_CE_LATITUDE: Your CE location latitude
   -  TF_CE_LONGITUDE: Your CE location longitude
   -  TF_CE_TOKEN: CE token ID generated from above `Create a token` section
   -  TF_VAR_SITE_NAME: CE site name to be registered. **NOTE: Make sure this matches with the token name created in `Create a token` section**
   -  TF_CLOUD_WORKSPACE\_\ *<Workspace Name>*: Create for each
      workspace in your workflow per each job

      -  EX: Create TF_CLOUD_WORKSPACE_EKS with the value ``EKS``

      -  EX: Create TF_CLOUD_WORKSPACE_INFRA with the value ``aws-infra``, etc

-  Check below image for more info on action secrets

.. image:: /workflow-guides/waf/f5-xc-waf-on-k8s/assets/actions-secrets.JPG

Workflow Runs
--------------

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

**Note:** Make sure to comment line no. 16 (# *.tfvars) in ".gitignore" file

**STEP 2:** Rename ``aws/infra/terraform.tfvars.examples`` to ``aws/infra/terraform.tfvars`` and add the following data: 

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

-  serviceName = "k8s service name of backend. If you are using our demo app set this to **productpage.default**."

-  serviceport = "k8s service port of backend. For bookinfo demo application you can keep this value as 9080."

-  advertise_sites = "set to true as we want to advertise this on CE"

-  http_only = "set to true as we want to use only http protocol"

**NOTE: Please don't add site_name varible once again here as this variable is already added in action secrets. Keep other fields as false**

Check below file content for sample tfvars data

.. code-block:: language
   
   #XC Global
   api_url = "https://tenant.console.ves.volterra.io/api"
   xc_tenant = "tenant-id"
   xc_namespace = "default"
   
   #XC LB
   app_domain = "waf-k8s.<domain>.com"
   
   #XC WAF
   xc_waf_blocking = true
   xc_data_guard = "false"
   
   # k8 pool and LB inputs
   k8s_pool = "true"
   serviceName = "productpage.default"
   serviceport = "9080"
   advertise_sites = "true"
   http_only = "true"
   eks_ce_site = "true"
   user_site = "true"
   
   #Only set to true if infrastructure is vk8s in XC
   vk8s = false
   xc_project_prefix = ""

   xc_delegation = "false"
   ip_address_on_site_pool = "false"
   
   #XC Azure CE site creation
   az_ce_site = "false"
   
   #XC Service Discovery
   xc_service_discovery = "false"
   
   #XC AI/ML Settings for MUD, APIP - NOTE: Only set if using AI/ML settings from the shared namespace
   xc_app_type = []
   xc_multi_lb = false
   
   #XC API Protection and Discovery
   xc_api_disc = false
   xc_api_pro = false
   xc_api_spec = []
   #Enable API schema validation
   xc_api_val = false
   #Enable API schema validation on all endpoints
   xc_api_val_all = false 
   #Validation properties for request and response validation
   xc_api_val_properties = [] #Example ["PROPERTY_QUERY_PARAMETERS", "PROPERTY_PATH_PARAMETERS", "PROPERTY_CONTENT_TYPE", "PROPERTY_COOKIE_PARAMETERS", "PROPERTY_HTTP_HEADERS", "PROPERTY_HTTP_BODY"]
   xc_resp_val_properties = [] #Example ["PROPERTY_HTTP_HEADERS", "PROPERTY_CONTENT_TYPE", "PROPERTY_HTTP_BODY", "PROPERTY_RESPONSE_CODE"]
   #Validation Mode active for requests and responses (false = skip)
   xc_api_val_active = false
   xc_resp_val_active = false
   #Validation Enforment Type (only one of these should be set to true)
   enforcement_block = false
   enforcement_report = false
   #Allow access to unprotected endpoints 
   fall_through_mode_allow = false
   #Enable API Validation custom rules
   xc_api_val_custom = false 
   
   #XC Bot Defense
   xc_bot_def = false
   
   #XC DDoS
   xc_ddos_pro = false
   
   #XC Malicious User Detection
   xc_mud = false
   
   # CE configs
   gcp_ce_site = "false"
   aws_ce_site = "false"
   
   # infra (Needed values: aws-infra, azure-infra, gcp-infra)
   aws   = "aws-infra"
   azure = ""
   gcp   = ""


**STEP 4:** Also update default value of ``aws_waf_ce`` variable in ``variables.tf`` file of ``/aws/eks-cluster``, ``/aws/eks-cluster/ce-deployment`` and ``/shared/booksinfo`` folders if it's not ``infra``. Commit and push your build branch to your forked repo, Build will run and can be monitored in the GitHub Actions tab and TF Cloud console

**STEP 5:** Once the pipeline completes, verify your CE, Origin Pool and LB were deployed or destroyed based on your workflow.

**STEP 6:** Open a linux shell or CMD and export your AWS credentials. 

**STEP 7:** Download the kubectl file by running this command ``aws eks update-kubeconfig --name <cluster-name> --region <region-name>`` and check services. 

**STEP 8:** Copy the load balancer DNS with name "lb-ver" and send request with XC LB FQDN as a Host header which should provide the application response as shown below

.. image:: /workflow-guides/waf/f5-xc-waf-on-k8s/assets/lb.jpg

.. image:: /workflow-guides/waf/f5-xc-waf-on-k8s/assets/postman.JPG


**STEP 9:** If you want to destroy the entire setup, checkout/create a new branch from ``deploy-waf-k8s`` branch with name ``destroy-waf-k8s`` which will trigger destroy work-flow to remove all resources
