F5 Distributed Cloud SMSv2 CE on Azure with WAF
#########################################################
Introduction
--------------
This demo guide provides step-by-step walkthrough for enabling Web Application Firewall (WAF) on Secure Mesh Site v2 (SMSv2) Customer Edge (CE) site manually using F5 Distributed Cloud (XC) console.

Contents
--------------
- Deploying SMSv2 CE in Azure
- Deploying Client VM and applications for testing
- Verifying Connectivity between CE site and Client VM through SLI
- Creating Origin Pool in Distributed Cloud
- Creating Load Balancer in Distributed Cloud
- Creating WAF configuration and assigning it to LB
- Verifying WAF with malicious requests

Prerequisites
--------------
Access to Azure portal
Access to F5 Distributed Cloud (XC) account

Steps to deploy Secure Mesh Site v2 in Azure
--------------
To deploy Secure Mesh Site v2 (SMSv2) in Azure, follow this link

.. image:: ./assets/azure/smsv2-azure-site.png

Steps to deploy VM (Client VM) running application workloads
--------------

1. Login to Azure portal

2. Search for “Virtal Machines” in search bar and click “Create”

3. Provide the required basic details for creating VM under “Basics” tab
    - Select the resource group already created for CE
    - Provide a name for the client VM
    - Select the region where you want to deploy
    - Select the OS image to be deployed in VM
    - Choose VM size based on requirements
    - Enter username and SSH key details to access the VM
    - Click “Next : Disks >”

.. image:: ./assets/azure/smsv2-azure-cvm-1.png

.. image:: ./assets/azure/smsv2-azure-cvm-2.png

4. Provide OS disk details under “Disks” tab based on requirement and click “Next : Networking >”

.. image:: ./assets/azure/smsv2-azure-cvm-3.png

5. Under “Networking” tab:
    - Choose the “Virtual Network” created earlier for the CE
    - Select the same “SLI” subnet which is attached to the CE
    - Create a “Public IP” to access the VM and deploy applications
    - Choose the “Network Security Group” created for this VM which has minimal access based on rules created

    .. image:: ./assets/azure/azure-client-nsg.png

    - Click “Review + create”

.. image:: ./assets/azure/smsv2-azure-cvm-4.png

6. Under “Review + create” tab, wait for the “Validation passed” message, review the configurations and click “Create”

.. image:: ./assets/azure/smsv2-azure-cvm-5.png

7. Wait for a few minutes for the deployment to succeed and VM to start running.
    - Public IP should be available, which is used for accessing the VM through SSH
    - Private IP should be assigned from SLI subnet selected

.. image:: ./assets/azure/smsv2-azure-cvm-6.png

8. Navigate to the CE site in F5 Distributed Cloud and ping the client VM private IP, it should be reachable

.. image:: ./assets/azure/smsv2-azure-cvm-7.png

9. Once the connection is established between CE site and VM, connect to the VM through SSH to deploy application. Execute below commands to deploy a vulnerable application (here “JuiceShop” is used)

$ sudo apt update
$ sudo apt install docker.io
$ sudo docker run -d -p 3000:3000 bkimminich/juice-shop

Accessing applications through Load Balancers
--------------
To access the applications installed in the Client machine through SMSv2 Customer Edge (CE), below configurations needs to be followed:

    - Creating “Origin Pool”
    - Creating “LB”
    - Creating “WAF” (recommended for security) and applying on the load balancer

Creating Origin Pool
--------------
1. Under “Multi-Cloud App Connect”, select Load Balancers-> Origin Pools. Click “Add Origin Pool”

.. image:: ./assets/azure/smsv2-azure-op1.png

2. Provide a name to the Origin Pool and click “Add Item” under Origin Servers

.. image:: ./assets/azure/smsv2-azure-op2.png

3. Select Origin Server Type IP address of Origin Server on given Sites and provide IP, select VMware site created from the dropdown and make sure Select Network on the site is set to “Inside Network” and click “Apply”

Note: IP address and Site might vary based on your configuration

.. image:: ./assets/azure/smsv2-azure-op3.png

4. Origin Server details will populate in the Origin Pool page, provide the port of the Ubuntu machine where the application is exposed (in this case 3000) and click “Add Origin Pool”

.. image:: ./assets/azure/smsv2-azure-op4.png

5. After creating the Origin Pool, this can be used in Load Balancer to access the application.

Creating Load Balancer
--------------
1. Under “Multi-Cloud App Connect”, select Load Balancers-> HTTP Load Balancers. Click “Add HTTP Load Balancer”

.. image:: ./assets/azure/smsv2-azure-lb1.png

2. Provide name for LB and domain with valid sub-domain

Note: You should be having domain to use for LB and it should be able to resolve for the FQDN to be accessible

.. image:: ./assets/azure/smsv2-azure-lb2.png

3. Click on “Add Item” under Origin Pool

.. image:: ./assets/azure/smsv2-azure-lb3.png

4. Select the origin pool created earlier and click “Apply”

.. image:: ./assets/azure/smsv2-azure-lb4.png

5. Enable “Web Application Firewall (WAF)” and click “Add item”

.. image:: ./assets/azure/smsv2-azure-lb5.png

6. Create a new WAF with below configurations and click “Add App Firewall”

.. image:: ./assets/azure/smsv2-azure-lb6.png

7. Select the WAF added and verify the Origin Pool and WAF in LB configuration

.. image:: ./assets/azure/smsv2-azure-lb7.png

8. Click “Add HTTP Load Balancer” and wait for around ~5 minutes for LB to provision and come up completely.

.. image:: ./assets/azure/smsv2-azure-lb8.png

9. Click “Add HTTP Load Balancer” and wait for around ~5 minutes for LB to provision and come up completely.

.. image:: ./assets/azure/smsv2-azure-lb9.png

10. Send some malicious traffic and observe the request gets blocked by F5 WAF

.. image:: ./assets/azure/smsv2-azure-lb10.png

Conclusion
--------------
This guide demonstrated how to enable WAF on an SMSv2 CE site using the F5 Distributed Cloud console. You deployed the CE in Azure, set up a test client, and configured origin pools and load balancers. WAF was successfully applied and verified with test attacks. This setup also supports additional security services like API Security, Bot Defense, and DDoS protection, allowing for flexible and robust application protection.