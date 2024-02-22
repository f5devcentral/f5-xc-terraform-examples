
Deploy Bot Defense for GCP with F5 XC BIG-IP Connector
========================================================

Objective :
-----------

This guide will outline the steps for implementing F5 XC Bot Defense to protect your GCP Kubernetes workloads using our BIG-IP Connector. First we will be deploying our sample application into GCP GKS (Google Kubernetes Service). Then we will deploy into GCP and front-end this application with F5's BIG-IP virtual appliance configured with our XC Bot Defense Connector. We'll leverage F5 XC to setup and download our Bot Defense Connector which will be deployed directly to the BIG-IP virtual appliance. This guide will outline the steps for implementing this infrastructure via Console Steps as well as Automated method using Terraform.



Bot Defense for GCP Architectural Diagram :
-----------------------
.. image:: assets/bot-gcp.png
   :width: 100%

Manual step by step process for deployment:
-------------------------------------------

Console Deployment Prerequisites:
^^^^^^^^^^^^^^

1. F5 Distributed Cloud Account (F5XC)
2. GCP Cloud Account (If you don't have an Azure subscription, create an Azure free account before you begin `here <https://portal.azure.com/>`_) 
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

.. image:: assets/az-login3.png
   :width: 100%


Create Azure Resource Group and Networks
=========================================

1. Create resource group from CLI using the "az group create --name az-xcbotdefense-rg1 --location westus2" command
2. Create our vnet and subnet resources in that group using the following command "az network vnet create --resource-group az-xcbotdefense-rg1 --name az-xcbotdefense-vnet1  --address-prefixes 10.248.0.0/16 --subnet-name az-xcbotdefense-subnet1 --subnet-prefix 10.248.1.0/24"

.. image:: assets/rg-create2.png
   :width: 100%


Create the AKS (Azure Kubernetes Service) Cluster
=================================================

1. To create an AKS cluster, we'll use the az aks create command. The following example creates a cluster named "az-xcbotdefense-cluster1" with one node and enables a system-assigned managed identity
2. Copy paste the command "az aks create --resource-group az-xcbotdefense-rg1 --name az-xcbotdefense-cluster1 --enable-managed-identity --node-count 1 --generate-ssh-keys" 
3. After a few minutes, the command completes and returns JSON-formatted information about the cluster

.. image:: assets/az-aks-create-2.png
   :width: 100%


Connect to the Cluster:
==========================

1. Configure kubectl to connect to your Kubernetes cluster using the az aks get-credentials command. This command downloads credentials and configures the Kubernetes CLI to use them.
2. Copy paste the following command into cli "az aks get-credentials --resource-group az-xcbotdefense-rg1 --name az-xcbotdefense-cluster1"
3. Verify the connection to your cluster using the "kubectl get nodes" command. This command returns a list of the cluster nodes.
4. The following sample output shows the single node created in the previous steps. Make sure the node status is Ready.

.. image:: assets/kubectl-getnodes3.png
   :width: 100%


Deploy our Sample Airline Application to the AKS Cluster:
=========================================================

1. Create a namespace using "kubectl create namespace az-xcbotdefense-namespace1"
2. Download the Kubernetes .yaml file for AKS using our sample Airline application `here <https://github.com/karlbort/f5-xc-waap-terraform-examples/blob/main/workflow-guides/bot/deploy-botdefense-in-azure-with-f5xc-bigip-connector/airline-app/az-xcbotdefense-app.yaml>`_ and save it to a working directory
3. From CLI Navigate to the directory containing the container image YAML file and run the command "kubectl apply -f az-xcbotdefense-app.yaml -n az-xcbotdefense-namespace1".
4. Check the status of the deployed pods using the "kubectl get pods -n az-xcbotdefense-namespace1" command. Make sure all pods are Running before proceeding.
5. Once this command has finished executing you can find the ingress IP by running the command "kubectl get services -n az-xcbotdefense-namespace1". Copy the external dns name as we'll be using this as the backend of our BIG-IP Virtual Server.

.. image:: assets/kubectl-apply3.png
   :width: 100%


Create VNET Peering:
====================

1. Navigate to the Azure Portal and in the upper left hamburger menu click on "Resource Groups". Then create a Filter of "az-xcbotdefense-rg1" so that we can see the resource group we created manually as well as the resource group automatically created by the aks cluster deployment.

.. image:: assets/az-rg1-2.png
   :width: 75%

2. Let's start with our configuration in the "MC_az-xcbotdefense-rg1_az-xcbotdefense-cluster2_westus2" cluster created resource group. Within the resource group navigate to the aks-vnet-123xxx > settings > peerings > add 

.. image:: assets/aks-peering2.png
   :width: 75%

3. Starting with "This Virtual Network" and enter the Peering link name of "aks-vnet-to-az-xcbotdefense-vnet1" 
4. Check "allow aks-vnet-123xxx to access the peered virtual network"
5. Check "allow aks-vnet-123456 to receive forwarded traffic from the peered virtual network"
6. Under "Remote virtual network" enter the peering link name of "az-xcbotdefense-vnet1-to-aks-vnet" 
7. Make sure you have the correct subsription selected and then find the remote virtual network in the dropdown by typing "az-xcbotdefense-vnet1"
8. select "allows az-xcbotdefense-vnet1" to access aks-vnet and "allow az-xcbotdefense-vnet1 to receive forwarded traffic from aks-vnet"

.. image:: assets/vnet-peering.png
   :width: 75%

9. Click Add and refresh the peerings page until the peering status shows "connected"
10. Navigate to your other resource group az-xcbotdefense-rg1 > az-xcbotdefense-vnet1 > peerings > and confirm it shows peerings status "connected". If not, you will need to configure the same on this vnet side but in reverse.

.. image:: assets/connected-peer.png
   :width: 75%


Create BIG-IP VM:
=================

1. Go to the Azure Console, search the services for "Marketplace" then search for "F5" and select "F5 BIG-IP Virtual Edition - BEST"

.. image:: assets/bigip-vm.png
   :width: 75%

2. This will open the "Create a virtual machine" page where we need to fill out the required information.
3. Under the Resource Group select from the drop-down menu the same resource group that we created "az-xcbotdefense-rg1"
4. For the instance details "virtual machine name" we'll name it "az-xcbotdefense-bigip1"
5. Make sure that the region is set to "(US) West US 2"
6. Set "Availability Options" to "No infrastructure redundancy required"
7. Set the "security type" to standard and leave the image as the "F5 BIG-IP Best" image. Also keep the VM architecture at x64
8. Set the VM Size to "Standard_D4s_v3"
9. For the administrator account select "password", set the username to f5admin, choose a password for the account

.. image:: assets/bigip-create1.png
   :width: 75%

10. Under inbound rules, select "none", we'll add some additional ports in future steps
11. Click next, and accept the defaults under "disks" and hit next again to the networking tab
12. Your virtual network and subnet should be pre-populated with az-xcbotdefense-vnet1 and az-xcbotdefense-subnet1 respectively. If not, please select them now. 
13. Public IP setting should be "(new) f5xc-bigip-botdefense-ip"
14. Set the NIC network security group to "basic". We'll go into the network security group after and add the required ports.
15. Under public inbound ports leave it set to "none"
16. Leave the defaults and load balancing options to "none"

.. image:: assets/bigip-create2.png
   :width: 75%

17. Accept all other defaults and click next through the remaining options and select "create"
18. Once the vm resources are done provisioning click on the "go to resource" button and review the BIG-IP resources that have been created. Note** Copy/paste your private and public IP Addresses and store them for later. 

.. image:: assets/bigip-create3.png
   :width: 100%


Create Inbound NSG for AZ-XCBOTDEFENSE-SUBNET1:
======================================= 

1. Navigate to resource groups > az-xcbotdefense-rg1 > az-xcbotdefense-bigip1-nsg > settings > "inbound security rules"
2. Add Source "myipaddress" destination "IP Addresses", Destination IP Address/CIDR "10.248.1.0/24",  service "custom", destination port ranges "8443", protocol tcp, action allow, save 

.. image:: assets/bigip-nsg1-2.png
   :width: 100%

3. Repeat the process and add Add Source "myipaddress", destination "IP Addresses", Destination IP Address/CIDR "10.248.1.0/24", service "SSH", action allow, save
4. Repeat the process and add Source "any", destination "10.248.1.0/24" service "HTTP", action "allow", save
5. Repeat the process and add Source IP Address "10.224.0.0/16" Destination IP Address, 10.248.1.0/24, service "custom", destination port ranges *, protocol any, action allow, Save
6. Repeat the process and add Source "Any", Destination "IP Addresses", Destination IP Address/CIDR "10.248.1.0/24, Service "HTTPS", Action allow, Save

.. image:: assets/bigip-nsg2-2.png
   :width: 100%

Create Route Table for BIG-IP to AKS:
=====================================

1. Now let's create the route-table for the BIG-IP to reach AKS using the following command "az network route-table create --name az-xcbotdefense-rt1 --resource-group az-xcbotdefense-rg1 --location westus2".
2. We'll add a route to get to the aks cluster vnet "az network route-table route create --name az-xcbotdefense-aks-route --resource-group az-xcbotdefense-rg1 --route-table-name az-xcbotdefense-rt1 --address-prefix 10.224.0.0/24 --next-hop-type VirtualAppliance --next-hop-ip-address 10.224.0.5"
3. Add a route for outbound internet traffic "az network route-table route create --name az-xcbotdefense-inet-route --resource-group az-xcbotdefense-rg1 --route-table-name az-xcbotdefense-rt1 --address-prefix 0.0.0.0/0 --next-hop-type Internet"
4. Now browse to the resource group az-xcbotdefense-rg1 > az-xcbotdefense-vnet1 > settings > subnets > az-xcbotdefense-subnet1 > route table > az-xcbotdefense-rt1 > save

.. image:: assets/rt1-subnet1.png
   :width: 100%

Add Route Table Entry For AKS to BIG-IP:
========================================

1. NOTE*** You will need the internal ip-address (10.248.1.x) of your big-ip which can be found from > resource groups > az-xcbotdefense-rg1 > az-xcbotdefense-bigip1 > networking > Private ip-address
2. We are going to configure this route entry from the Azure Portal. Navigate to resource groups > MC_az-xcbotdefense-rg1_az-xcbotdefense-cluster_westus2 > aks-agentpool-123xxx-routetable > settings > routes > add 
3. Route name "aks-to-bigip", Destination type "IP Addresses", Destination IP "10.248.1.0/24", Next hop type, "virtual appliance", Next hop address "<use-internal-bigip-address>"
4. Click Add

.. image:: assets/route-aks-to-bigip.png
   :width: 100%


Add Inbound HTTP Rule to AKS NSG:
=================================

1. Browse to resource MC_az-xcbotdefense-rg1_az-xcbotdefense-cluster_westus2 > aks-agentpool-123456-nsg > settings > inbound security rules
2. Add source "ip addresses", source ip addresses/cidr 10.248.1.0/24, destination "IP Addresses", destination ip addresses/cidr "10.224.0.0/16" , service HTTP, and click add

.. image:: assets/aks-nsg1.png
   :width: 100%

Create BIG-IP Service Pool :
============================

1. NOTE** You will need the external IP Address of your cluster from "kubectl get services -n az-xcbotdefense-namespace1"
2. Navigate to resource group az-xcbotdefense-rg1 > az-xcbotdefense-bigip1 and note the public IP Address on the overview page in the networking section
3. Open a browser and access big-ip with https://<external-ip-address>:8443 (replacing "external-ip-address" with you guessed it... your pub BIG-IP... IP")
4. Login with the credentials your provided for username "f5admin"
5. Under the Main tab go to local traffic > pools > create 
6. Name "az-xcbotdefense-app1", Health Monitors "tcp"
7. Leave the default load balancing method at "Round Robin", add the node name of "az-xcbotdefense-app1", in the address field, paste the external ip from previous steps "10.224.0.5", set service port to "80 HTTP", Add, finished
8. If you refresh your page the status should turn green indicating successful health monitor to the aks app. 

.. image:: assets/bigip-pool.png
   :width: 100%

.. image:: assets/bigip-pool-green.png
   :width: 100%

Create BIG-IP Virtual Server:
=============================

1. First thing you will need to grab here is the private address in that's been assigned to your BIG-IP. Navigate to resource groups > az-xcbotdefense-rg1 > az-xcbotdefense-bigip1 and not the private IP address under the networking section. 
2. Within the BIG-IP navigate to Local traffic > virtual servers > CREATE
3. Name "az-xcbotdefense-vip1", source address, 0.0.0.0/0, Destination Address/Mask, enter "<bigip-private-ip>/32" (Private IP of BIG-IP from previous step), service port 80 http 
4. set the HTTP Profile (Client) to "http", HTTP Profile (server) "use client profile"

.. image:: assets/bigip-vip1-1.png
   :width: 100%

5. set "Source Address Translation to "AutoMap" 
6. Under resources set the Default Pool to "az-xcbotdefense-app1" and click finished
7. Verify you can access your AKS App through the BIG-IP by going to http://bigippublicip and it should load the F5 Airline Application 

.. image:: assets/bigip-vip1-2.png
   :width: 100%

.. image:: assets/f5air.png
   :width: 100%

Creating the XC Bot Defense Profile:
==============================================

1. Logging into your tenant via https://console.ves.volterra.io ensure you have a unique namespace configured. If not, navigate to Administration --> My Namespaces --> Add New
2. Switch into your newly created namespace
3. Click on the Bot Defense Tile and go to manage > applications > add application 

.. image:: assets/xc-bot-tile.png
   :width: 100%

.. image:: assets/bot-manage.png
   :width: 100%

3. Use the name "az-xcbotdefense-profile1" and a description of "XC Bot Defense Connector for BIG-IP in Azure" 
4. Set the Application Region to "US", Connector Type "F5 BIG-IP iApp (v17.0 or greater) > save and exit

.. image:: assets/bigip-connector-add.png
   :width: 100%

5. Click the Elipses and copy all of the ID's, keys, hostnames, and headers and save them into a file 

.. image:: assets/connector-manage.png
   :width: 100%

6. Now Login to your BIG-IP and click on the distributed Cloud services > Bot Defense > Create

.. image:: assets/bigip-bdprofile1.png
   :width: 100%

7. Enter profile name "az-xcbotdefense-profile1"
8. Paste Application ID, Tenant ID, API Hostname, API Key, and Telemetry Header Prefix from XC Console 
9. Leave the default JS Insertion Configuration settings of /customer.js, After <head>, Async with no caching

.. image:: assets/bigip-bdprofile1-3.png
   :width: 100%

10. Under protected endpoints, enter the public IP for your BIG-IP/Application, set the path to /user/signin, set the endpoint label to Login, and check "PUT" and "POST" checkbox with mitigation action of "block", don't forgest to click "Add" to add the rule

.. image:: assets/protected-endpoints.png
   :width: 100%

11, Under the Advanced Features, click the plus sign next to "protection pool" and name it "ibd-webus.fastcache.net"
12. add a health monitor of https, under node name call it ibd-webus.fastcache.net, address ibd-webus.fastcache.net, service port 443 https, click add and finished
13. Back on the Bot Defense profile page select the newly created profile from the menu and set the ssl profile to "serverssl" and click finished

.. image:: assets/bd-protection-pool1.png
   :width: 100%

.. image:: assets/bd-protectionpool1-1.png
   :width: 100%

.. image:: assets/bd-protectionpool1-2.png
   :width: 100%


Binding the XC Bot Profile to the Virtual Sever:
================================================
 
1. Within the BIG-IP navigate to Local Traffic > Virtual Servers > az-xcbotdefense-vip1 > and click on the tab at the top called "distributed Cloud Services"
2. Change the Bot Defense drop down from "disabled" to "enabled" then select the "az-xcbotdefense-connector1" profile and click update 
3. Now that we've applied the Bot Defense Connector to our Virtual Server Lets test it out. 

.. image:: assets/vip-bdprofile2.png
   :width: 100%

Validating the Java Script Injection:
=====================================

1. Open a browser and load the app through the BIG-IP by going to http://bigippublicip and it should load the F5 Airline Application
2. Right click anywhere on the page and click "inspect"
3. This opens the developer tools on the right. Under the "elements" tab expand the <head> tag
4. Within the <head> tag you should see three lines containing the following: 1) src="/customer1.js?matcher", 2) src="/customer1.js?single"></script>, 3) src="/customer1.js?async"
5. This confirms that the Javascript is being injected appropriately into your aks application via the BIG-IP

.. image:: assets/jsverification.png
   :width: 100%


Simulating Bot Traffic with CURL:
=================================

1. Within this repo you can download the `curl-stuff.sh <https://github.com/karlbort/f5-xc-waap-terraform-examples/blob/main/workflow-guides/bot/deploy-botdefense-in-azure-with-f5xc-bigip-connector/validation-tools/curl-stuff.sh>`_ Bash script in the validation-tools directory to run it against your web application to generate some generic Bot Traffic
2. After you've downloaded the curl-stuff.sh script you can edit the file using a text editor and replace the domain name on line 3 with the public IP Address of your BIG-IP. For example, curl -s http://x.x.x.x/user/signin NOTE*** ensure that you maintain the "/user/signin" path as this is the protected endpoint we configured in our profile.
3. Run the curl script with sh curl-stuff.sh. Note the failure response in the screenshot below

.. image:: assets/curl-stuff2.png
   :width: 100%


View Bot Traffic​:
=================

1. Now let’s return to F5 XC Console and show the monitoring page over Overview > Monitor
2. Log in to your F5 Distributed Cloud Console
3. Go to the Dashboard page of XC console and click Bot Defense.
4. Make sure you are in the correct Namespace
5. Under Overview click Monitor and you can see our the bot detections of our newly protected Cloudfront Application. 
6. Here you can monitor and respond to events that are identified as Bot traffic

.. image:: assets/bdmonitor2.png
   :width: 100%

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


