Manual step by step process to deploy application in VM
=======================================================

Pre-requisites
******************
- Access to Azure subscription. 
- Access to F5 Distributed Cloud account.
- Install Azure CLI or Putty to SSH to VM
- Web browser to access the application.

Step 1: Configure credentials in F5 Distributed Cloud Console for Azure
#########################################################################
To deploy an Azure Vnet site from F5XC, first we have to configure cloud credentials in XC. Please refer `DevCentral Article <https://community.f5.com/t5/technical-articles/creating-a-credential-in-f5-distributed-cloud-for-azure/ta-p/298316>`_ and follow the steps to configure. 

Step 2: Create Resource group, Vnet and Subnet in Azure 
########################################################

* **Create Resource group:**   Login to Azure console > search for "Resource groups" > click "Create" button then select your subscription, provide resource group name and region > click "Review + create" and "Create"
* **Create Virtual Network:** Search for "Virtual networks" and click "Create" button then select your subscription, set the above created resource group name, new virtual network name and region > Navigate to "IP addresses" tab on top > Configure your virtual network address space and subnet > Click "Review + create” and "Create"

Step 3: Create Virtual Machine and deploy application in it
#############################################################

Note: Main requirement for this use case is to have an application which is not accessible from Internet which means VM should not have public IP/FQDN.

* Login to the Azure portal with your credentials.
* Click on Create and create a new Virtual Machine. In this demo guide, we have used Ubuntu Server 20.04.
* While creating Virtual machine, make sure to select the correct subscription and same resource group which was created in step 2.
* Provide all the necessary details in Basics Section like Name of the VM, Region, Availability Zone, Image, Size, Username, Key pair name, Inbound port rules. 
* Navigate to Networking section, select the Virtual network and Subnet which is created in step 2.
* Click on “Review and Create”, Review all the necessary parameters and deploy a Virtual Machine.
* SSH to created Virtual Machine using Public IP and install docker in it.
* Choose the application you want to use and deploy the application within Virtual Machine. In this scenario, we have deployed DVWA application for testing purpose using docker command: 
  "docker run -d -p 80:80 vulnerables/web-dvwa"

* We should not have Public IP address/FQDN for the VM so disassociate the existing public IP address from the VM and delete it.
* Make a note of the private IP of the virtual machine.

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

* Select Manage > Load Balancers > HTTP Load Balancers and click Add HTTP Load Balancer
* Enter a name for the new load balancer. Optionally, select a label and enter a description.
* In the Domains field, enter a domain name
* From the Load Balancer Type drop-down menu, select HTTP
* In the Origins section, click Add Item to create an origin pool.
* In the origin pool field dropdown, click Add Item
* Enter name, in origin server section click Add Item
* Select “IP address of Origin Server on given Sites” > Provide private IP of the virtual machine > Choose Azure Vnet Site in Site dropdown same as your Vnet site > Choose Outside Network under Select Network from the Site > Click on Apply > In Origin server port, provide the port of the deployed application.

.. figure:: assets/vm-op.JPG

.. figure:: assets/vm_port.JPG

* Click Continue and then Apply. 
* Enable WAF, create and attach a WAF policy in Blocking mode.
* Move to VIP Advertisement field and choose Internet. 
* Save and apply changes.

Step 6: Access the deployed application 
########################################

* Open a browser. 
* Access the application using the domain name configured in HTTP load balancer. 
* Make sure that the application is accessible.

.. figure:: assets/DVWA.JPG

* Now let us verify applied WAF policy.
* Generate a XSS attack by adding ?a=<script> tag in the URL along with the domain name and observe that WAF policy blocks the access.
* Application should not be accessible.

.. figure:: assets/dvwa-block.JPG

* Observe security event log for more details.

.. figure:: assets/waf-block-vm.JPG

.. figure:: assets/waf-block2-vm.JPG

Conclusion
***********
By following the above provided steps, one can easily configure WAF(on RE)+Appconnect usecase. When end user is trying to access the backend private application, user will connect to the closest RE and the request will be inspected by the WAF security policy. From there, the request will be traversed over XC Global Network and reach the respective CE site through IPSEC tunnel which in turn communicates with the backend application and provides the necessary data.

**Support**
************
For support, please open a GitHub issue. Note, the code in this repository is community supported and is not supported by F5 Networks. 
