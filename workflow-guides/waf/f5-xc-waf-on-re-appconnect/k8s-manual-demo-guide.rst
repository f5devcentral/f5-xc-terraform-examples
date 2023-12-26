Manual step by step process to deploy application in Kubernetes Cluster:
===============================================

Pre-requisites
******************
- Access to Azure subscription. 
- Access to F5 Distributed Cloud account.
- Install Azure CLI and kubectl command line tool to connect and push the app manifest file to AKS cluster
- Web browser to access the application.

Step 1: Configure credentials in F5 Distributed Cloud Console for Azure
#########################################################################
To deploy an Azure Vnet site from F5XC, first we have to configure cloud credentials in XC. Please refer `DevCentral Article <https://community.f5.com/t5/technical-articles/creating-a-credential-in-f5-distributed-cloud-for-azure/ta-p/298316>`_ and follow the steps to configure. 

Step 2: Create Resource group, Vnet and Subnet in Azure 
########################################################

* **Create Resource group:**   Login to Azure console > search for "Resource groups" > click "Create" button then select your subscription, provide resource group name and region > click "Review + create" and "Create"
* **Create Virtual Network:** Search for "Virtual networks" and click "Create" button then select your subscription, set the above created resource group name, new virtual network name and region > Navigate to "IP addresses" tab on top > Configure your virtual network address space and subnet > Click "Review + create” and "Create"

Step 3: Create Kubernetes Cluster and deploy application in it 
###############################################################

Note: Main requirement for this use case is to have an application which is not accessible from Internet which means cluster node should not have public IP/FQDN.

* Search for 'Kubernetes services'.
* Click on 'Create' button and select 'Create Kubernetes cluster'.
* Select the correct subscription and choose the resource group which is created in step 2.
* Provide all the necessary cluster details and primary node pool fields as needed.
* Navigate to 'Networking' tab and select 'Bring your own virtual network'
* Select the Virtual network which is created in step 2.
* Click “Review + create” and create the cluster.
* Connect to the created AKS cluster.  
* Choose your application and deploy it. In this scenario, we are deploying Online boutique application using the `manifest file <https://github.com/GoogleCloudPlatform/microservices-demo/blob/main/release/kubernetes-manifests.yaml>`_. Make changes in the manifest file according to the requirement.
* Execute “kubectl apply -f <your_manifest.yaml>”
* Execute “kubectl get pods” command to check the deployment status of the pods.

.. figure:: assets/pods_latest.JPG

Step 4: Deploy Azure Vnet site from F5XC console:
##################################################

* Login to F5XC Console and navigate to "Multi-Cloud Network Connect" from homepage.
* Select "Manage > Site Management > Azure VNET Sites" and click on "Add Azure VNET Site".
* Select the Azure cloud credentials from the dropdown menu which was configured in Step 1. 
* Give a Vnet site name in “Name” field, resource group name in the “Resource Group” field. Do not provide an already existing resource group name.
* Choose appropriate Azure region from the common value recommendations.
* Select Existing Vnet Parameters and provide existing Vnet details like resourge group and Vnet name which was created in step 2. 

.. figure:: assets/vnet.JPG

* Choose Ingress Gateway (One Interface), click on Configure then click Add Item in Ingress Gateway (One Interface) Nodes in AZ. 
* Select Azure AZ name, Existing Subnet and provide subnet name which was created in step 2. Click Apply and Save the config.

.. figure:: assets/subnet.JPG

* Add a public SSH key to access the site. (If you don’t have public SSH key, you can generate one using “ssh-keygen” command and then display it with the command “cat ~/.ssh/id_rsa.pub”). 
* In Advanced Configuration, select Show Advanced Fields then choose "Allow access to DNS, SSH services on Site" from the dropdown. 
* Click Save and Exit. 
* Click on Apply in Actions column. 
* Wait for the apply process to complete and the status to change to Applied. 

Step 5: Create origin pool and HTTP LB in F5XC console
########################################################

**Create service discovery object**

* Navigate to "Multi-Cloud App Connect" from homepage.
* Select "Manage > Service Discoveries" and Click on "Add Discovery"
* Provide a name, select vnet site created in step 4 and select network type as "Site Local Network"

.. figure:: assets/service_discovery.JPG

* Select Discovery Method as "K8S Discovery Configuration"
* Select Kubernetes Credentials as Kubeconfig, and add the Kubeconfig file of AKS Cluster created in Step 3, Apply the changes.
* Services will be discovered by F5XC.

.. figure:: assets/discovered_services.JPG

**Configure HTTP Load Balancer and Origin Pool**

* Select Manage > Load Balancers > HTTP Load Balancers and click Add HTTP Load Balancer
* Enter a name for the new load balancer. Optionally, select a label and enter a description.
* In the Domains field, enter a domain name
* From the Load Balancer Type drop-down menu, select HTTP
* In the Origins section, click Add Item to create an origin pool.
* In the origin pool field dropdown, click Add Item
* Enter name, in origin server section click Add Item
* If application is deployed in Kubernetes Cluster, Select “K8s Service Name of Origin Server on given Sites” > Add the service name of frontend microservice as "frontend.default" > Select the Azure Vnet site created in Step 6 > Select Network on the site as "Outside Network" > In Origin server port add port number "80" of the discovered frontend service , Click continue and then Apply.

.. figure:: assets/k8_op.JPG

.. figure:: assets/op_port.JPG

* Click Continue and then Apply. 
* Enable WAF, create and attach a WAF policy in Blocking mode.
* Move to VIP Advertisement field and choose Internet. 
* Save and apply changes.

Step 6: Access the deployed application 
########################################

* Open a browser. 
* Access the application using the domain name configured in HTTP load balancer. 
* Make sure that the application is accessible.

.. figure:: assets/botique.JPG

* Now let us verify applied WAF policy.
* Generate a XSS attack by adding ?a=<script> tag in the URL along with the domain name and observe that WAF policy blocks the access.
* Application should not be accessible.

.. figure:: assets/waf_block.JPG

* Observe security event log for more details.

.. figure:: assets/waf_event.JPG

.. figure:: assets/waf_event2.JPG

Conclusion
***********
By following the above provided steps, one can easily configure WAF(on RE)+Appconnect usecase. When end user is trying to access the backend private application, user will connect to the closest RE and the request will be inspected by the WAF security policy. From there, the request will be traversed over XC Global Network and reach the respective CE site through IPSEC tunnel which in turn communicates with the backend application and provides the necessary data.

**Support**
************
For support, please open a GitHub issue. Note, the code in this repository is community supported and is not supported by F5 Networks. 
