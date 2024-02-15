
Deploy Bot Defense for Azure with F5 XC BIG-IP Connector
========================================================

Objective :
-----------

This guide will outline the steps for implementing F5 XC Bot Defense to protect your Azure Kubernetes workloads using our BIG-IP Connector. First we will be deploying our sample application into Azure AKS (Azure Kubernetes Service). Then we will deploy into Azure and front-end this application with F5's BIG-IP virtual appliance configured with our XC Bot Defense Connector. We'll leverage F5 XC to setup and download our Bot Defense Connector which will be deployed directly to the BIG-IP virtual appliance. This guide will outline the steps for implementing this infrastructure via Console Steps as well as Automated method using Terraform.



Bot Defense for Azure Architectural Diagram :
-----------------------
.. image:: assets/azurebd.png
   :width: 100%

Manual step by step process for deployment:
-------------------------------------------

Console Deployment Prerequisites:
^^^^^^^^^^^^^^

1. F5 Distributed Cloud Account (F5XC)
2. Azure Cloud Account (If you don't have an Azure subscription, create an Azure free account before you begin `here <https://portal.azure.com/>`_) 
3. Azure CLI: Install the Azure CLI on your local machine. You can download it from the official Azure `CLI website <https://learn.microsoft.com/en-us/cli/azure/install-azure-cli>`_
4. kubectl: Install kubectl on your local machine. You can find installation instructions on the `kubectl installation page <https://kubernetes.io/docs/tasks/tools/>`_



Steps:
^^^^^^


Signing into Azure CLI
======================

1. From CLI run the "az login" command
2. If the Azure CLI can open your default browser, it initiates authorization code flow and opens the default browser to load an Azure sign-in page
3. Sign in with your account credentials in the browser
4. If you have multiple Azure subscriptions, select the appropriate subscription ID in which the resources should be billed using the az account set command

.. image:: assets/azlogin2.png
   :width: 75%

Create Azure Resource Group and Networks
=========================================

1.Create resource group from CLI using the "az group create --name az-xcbotdefense-rg1 --location westus2" command

.. image:: assets/azresourcegroup3.png
   :width: 100%

2. Next lets create our vnet and subnet resources in that group using the following command "az network vnet create --resource-group az-xcbotdefense-rg1 --name az-xcbotdefense-vnet1  --address-prefixes 10.248.0.0/16 --subnet-name az-xcbotdefense-subnet1 --subnet-prefix 10.248.1.0/24"

Create the AKS (Azure Kubernetes Service) Cluster
=================================================

1. To create an AKS cluster, we'll use the az aks create command. The following example creates a cluster named "az-xcbotdefense-cluster1" with one node and enables a system-assigned managed identity
2. Copy paste the command "az aks create --resource-group az-xcbotdefense-rg1 --name az-xcbotdefense-cluster1 --enable-managed-identity --node-count 1 --generate-ssh-keys" 
3. After a few minutes, the command completes and returns JSON-formatted information about the cluster

Connect to the Cluster:
==========================

1. Configure kubectl to connect to your Kubernetes cluster using the az aks get-credentials command. This command downloads credentials and configures the Kubernetes CLI to use them.
2. Copy paste the following command into cli "az aks get-credentials --resource-group az-xcbotdefense-rg1 --name az-xcbotdefense-cluster1"
3. Verify the connection to your cluster using the "kubectl get nodes" command. This command returns a list of the cluster nodes.
4. The following sample output shows the single node created in the previous steps. Make sure the node status is Ready.

.. image:: assets/getnodes.png
   :width: 100%

Deploy our Sample Airline Application to the AKS Cluster:
=========================================================

1. Create a namespace using "kubectl create namespace az-xcbotdefense-namespace1"
2. Download the Kubernetes .yaml file for AKS using our sample Airline application `here <https://github.com/karlbort/f5-xc-waap-terraform-examples/blob/main/workflow-guides/bot/deploy-botdefense-in-azure-with-f5xc-bigip-connector/airline-app/az-xcbotdefense-app.yaml>`_ and save it to a working directory
3. From CLI Navigate to the directory containing the container image YAML file and run the command "kubectl apply -f az-xcbotdefense-app.yaml -n az-xcbotdefense-namespace1".
4. Check the status of the deployed pods using the "kubectl get pods -n az-xcbotdefense-namespace1" command. Make sure all pods are Running before proceeding.
5. Once this command has finished executing you can find the ingress IP by running the command "kubectl get services -n az-xcbotdefense-namespace". Copy the external dns name as we'll be using this as the backend of our BIG-IP Virtual Server.

.. image:: assets/getpods2.png
   :width: 100%

Create VNET Peering:
====================

1. Navigate to the Azure Portal and find "Resource groups" and filter by "az-xcbotdefense-rg1" so that we can see the resource group we created manually as well as the resource group automatically created by the aks cluster deployment.
2. Let's start with our configuration in the "MC_az-xcbotdefense-rg1_az-xcbotdefense-cluster2_westus2" cluster created resource group. Within the resource group navigate to the aks-vnet-123xxx > settings > peerings > add 
3. Starting with "This Virtual Network" and enter the Peering link name of "aks-vnet-to-az-xcbotdefense-vnet1" 
4. Check "allow aks-vnet-123xxx to access the peered virtual network"
5. Check "allow aks-vnet-123456 to receive forwarded traffic from the peered virtual network"
6. Under "Remote virtual network" enter the peering link name of "az-xcbotdefense-vnet1-to-aks-vnet" 
7. Make sure you have the correct subsription selected and then find the remote virtual network in the dropdown by typing "az-xcbotdefense-vnet1"
8. select "allows az-xcbotdefense-vnet1" to access aks-vnet and "allow az-xcbotdefense-vnet1 to receive forwarded traffic from aks-vnet"
9. Click Add and refresh the peerings page until the peering status shows "connected"
10. Navigate to your other resource group az-xcbotdefense-rg1 > az-xcbotdefense-vnet1 > peerings > and confirm it shows peerings status "connected". If not, you will need to configure the same on this vnet side but in reverse.

Create BIG-IP VM:
=================

1. Go to the Azure Console, search the services for "Marketplace" then search for "F5" and select "F5 BIG-IP Virtual Edition - BEST"
2. This will open the "Create a virtual machine" page where we need to fill out the required information.
3. Under the Resource Group select from the drop-down menu the same resource group that we created "az-xcbotdefense-rg1"
4. For the instance details "virtual machine name" we'll name it "az-xcbotdefense-bigip1"
5. Make sure that the region is set to "(US) West US 2"
6. Set "Availability Options" to "No infrastructure redundancy required"
7. Set the "security type" to standard and leave the image as the "F5 BIG-IP Best" image. Also keep the VM architecture at x64
8. Set the VM Size to "Standard_D4s_v3"
9. For the administrator account select "password", set the username to f5admin, choose a password for the account
10. Under inbound rules, select "none", we'll add some additional ports in future steps
11. Click next, and accept the defaults under "disks" and hit next again to the networking tab
12. Your virtual network and subnet should be pre-populated with az-xcbotdefense-vnet1 and az-xcbotdefense-subnet1 respectively. If not, please select them now. 
13. Public IP setting should be "(new) f5xc-bigip-botdefense-ip"
14. Set the NIC network security group to "basic". We'll go into the network security group after and add the required ports.
15. Under public inbound ports leave it set to "none"
16. Leave the defaults and load balancing options to "none"
17. Accept all other defaults and click next through the remaining options and select "create"
18. Once the vm resources are done provisioning click on the "go to resource" button and review the BIG-IP resources that have been created

Create NSG for AZ-XCBOTDEFENSE-SUBNET1:
======================================= 

1. navigate to resource groups > az-xcbotdefense-rg1 > az-xcbotdefense-bigip1-nsg > settings > inbound security virtualNetworks
2. Add Source "myipaddress" destination "any" service, custom, destination port ranges 8443, protocol tcp, action allow, Save 
3. Repeat the process and add Source "myipaddress" destination "any" service, SSH, action allow, Save
4. Repeat the process and add Source "any" destination "any" service, HTTP, action allow, Save
5. Repeat the process and add Source IP Address "10.224.0.0/16" Destination IP Address, 10.248.1.0/24, service "custom", destination port ranges *, protocol any, action allow, Save
6. Repeat the process and add Source "Any", Destination "Any", Service "HTTPS", Action allow, Save


Route Table Creating:
====================

3. Now let's create the route-table with the "az network route-table create --name az-xcbotdefense-rt --resource-group az-xcbotdefense-rg --location westus2" command
4. We'll add a route to get to the aks cluster vnet "az network route-table route create --name az-xcbotdefense-aks-route --resource-group az-xcbotdefense-rg --route-table-name az-xcbotdefense-rt --address-prefix 10.224.0.5/32 --next-hop-type VirtualAppliance --next-hop-ip-address 10.224.0.5"
5. Add a route for outbound internet traffic "az network route-table route create --name az-xcbotdefense-inet-route --resource-group az-xcbotdefense-rg --route-table-name az-xcbotdefense-rt --address-prefix 0.0.0.0/0 --next-hop-type Internet"
6. Now let's login to the Azure Portal and in the upper left hamburger menu click on "Resource Groups". Then Filter the results by searching for "az-xcbotdefense" RG

.. image:: assets/az-rg.png
   :width: 75%

7. Next we'll click on the az-xcbotdefense-rg group and click on the az-xcbotdefense-vnet "virtual network". On the left navigation of the virtual network under settings click on "subnets" and click into the the az-xcbotdefense-subnet. From here you'll select the "route table" drop down menu and search for "az-xcbotdefense-rt" and associate it and save. 

.. image:: assets/subnet-rt.png
   :width: 100%





Deploy F5 BIG-IP Virtual Appliance:
==================================
1. Go to the Azure Console, search the services for Marketplace then search for "F5" and select "F5 BIG-IP Virtual Edition - BEST"
2. This will open the "Create a virtual machine" page where we need to fill out the required information. 
3. Under the Resource Group select from the drop-down menu the same resource group that we deployed our AKS application into "az-xcbotdefense"
4. For the instance details "virtual machine name" we'll name it "f5xc-bigip-botdefense"
5. Make sure that the region is set to "(US) West US 2"
6. Set "Availability Options" to "No infrastructure redundancy required"
7. Set the "security type" to standard and leave the image as the "F5 BIG-IP Best" image. Also keep the VM architecture at x64
8. Set the VM Size to "Standard_B2ms"
9. For the administrator account select "password", set the username to anything of your choosing, choose a password for the account
10. Under inbound rules, select "none", we'll add some additional ports in future steps

.. image:: assets/vmbasics3.png
   :width: 75%

11. Click next, and accept the defaults under "disks" and hit next again
12. Your virtual network and subnet should be pre-populated with az-xcbotdefense-vnet and az-xcbotdefense-subnet respectively. 
13. Public IP setting should be "(new) f5xc-bigip-botdefense-ip"
14. Set the NIC network security group to "basic". We'll go into the network security group after and add the required ports. 
15. Under public inbound ports leave it set to "none"
16. Leave the defaults and load balancing options to "none"
17. Accept all other defaults and click next through the remaining options and select "create"
18. Once the vm resources are done provisioning clicking on the "go to resource" button and review the BIG-IP resources that have been created 

.. image:: assets/vmcomplete.png
   :width: 100%

Create Inbound Traffic Rules:
=============================

1. In the Azure portal, click on the hamburger menu in the top left and select "Resource Groups" then filter for our RG "az-xcbotdefense" and select it
2. Filter for our our network security group we created called "abcdefg" and click on it
3. In the left menu, under Settings, click Inbound security rules. Click "add". Under the source IP you can select "myIPAddress" from the drop down, leave the source port at "*", set the destination port to 22, with protocol of TCP and click add. 
4. Repeat these steps, using 8443 as the Destination port range. This allows management traffic for port 8443/tcp to reach the BIG-IP VE.

.. image:: assets/nsgadd3.png
   :width: 75%


Create a pool and add members to it:
====================================

1. Log in to your F5 BIG-IP VE appliance with https://<external-ip-address>:8443
2. On the Main tab, click Local Traffic -> Pools --> Create New
3. In the Name field, type airlineapp_web_pool
4. For Health Monitors, move http from the Available to the Active list
5. Leave the load balancing method at the default setting of Round Robin
6. In the New Members section, name should be aks-airlineapp, type the IP address of the application server, and set the port to 80/http

.. image:: assets/trafficpools.png
   :width: 100%


Create a Virtual Server:
=======================





Simulating Bot Traffic with CURL:
=================================

1. Within this repo you can download the curl-stuff.sh Bash script in the validation-tools directory to run it against your web application to generate some generic Bot Traffic
2. After you've downloaded the `curl-stuff.sh <https://github.com/karlbort/f5-xc-waap-terraform-examples/tree/main/workflow-guides/bot/deploy-botdefense-for-awscloudfront-distributions-with-f5-distributedcloud/validation-tools/curl-stuff.sh>`__ bash script you can edit the file using a text editor and replace the ".cloudfront.net" domain name on line 3 with the DNS name and path of your actual Cloudfront Distribution for your application. For example, curl -s https://abcdefg.cloudfront.net/user/signin -i -X POST -d "username=1&password=1" you would replace the "abcdefg.cloudfront.net" hostname with the DNS name for your newly deployed Cloudfront protected application. Note** Make sure to keep the /user/signin path of the URI as this is the protected endpoint we configured in the Bot Defense Policy.
3. Run the CURL script using "sh curl-stuff.sh" once or twice to generate bot traffic. Or you can always just copy the CURL command out of the script and manually enter it into a command prompt a few times.

.. image:: assets/cloudfront-curl.png
   :width: 75%

View Bot Traffic​:
=================

1. Now let’s return to F5 XC Console and show the monitoring page over Overview > Monitor
2. Log in to your F5 Distributed Cloud Console
3. Go to the Dashboard page of XC console and click Bot Defense.
4. Make sure you are in the correct Namespace
5. Under Overview click Monitor and you can see our the bot detections of our newly protected Cloudfront Application. 

.. image:: assets/bd-mon.png
   :width: 100%

6. Here you can monitor and respond to events that are identified as Bot traffic


Step by step process using automation scripts:
----------------------------------------------

**Coming soon**

Development
-----------

Outline any requirements to setup a development environment if someone
would like to contribute. You may also link to another file for this
information.

Support
-------

For support, please open a GitHub issue. Note, the code in this
repository is community supported and is not supported by F5 Networks.

