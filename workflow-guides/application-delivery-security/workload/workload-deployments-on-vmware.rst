F5 Distributed Cloud Workload Deployments on VMware
#########################################################
This article serves as the initial setup for the VMware platform in “F5 Distributed Cloud Application Delivery and Security for Scalable Enterprise Workload Deployments across Heterogeneous Environments” scenario. This document covers:

Customer Edge (CE) Setup

Client VM(Ubuntu) Installation

Application Access via Load Balancers

VMware ESXi used in this demonstration is deployed on Dell PowerEdge-R640 bare metal. The CE VM is booted using the OVF image of SMSv2 CE downloaded from F5 Distributed Cloud. Once the CE VM is up and site is online, VM running application workloads (Ubuntu VM) is also deployed in the same ESXi and connected to CE using Site Local Inside (internal_network_pg) interface, so that applications are not exposed directly.

*Note: This scenario uses VMware On-Prem, but it can also be deployed on GCP and Azure.*

VMware Architecture
--------------
.. image:: ./assets/

Steps to Deploy Secure Mesh Site v2 on VMware
--------------
*Note 1: Resources required to create CE VM: Minimum 8 vCPUs, 32 GB RAM, and 80 GB disk storage, please refer below link for more details on sizing and resources:*
`Customer Edge Site Sizing Reference <https://docs.cloud.f5.com/docs-v2/multi-cloud-network-connect/reference/ce-site-size-ref>`__

*Note 2: For this demonstration ESXi 6.7.0 is used, if vSphere is being used, please refer the below link:*
`Deploy Secure Mesh Site v2 on VMware (ClickOps) <https://docs.cloud.f5.com/docs-v2/multi-cloud-network-connect/how-to/site-management/deploy-sms-vmw-clickops>`__

Create Site Object
--------------
Create a secure mesh site object in the Distributed Cloud Console and select VMware as the provider.

**Step 1: Enter metadata information for site.**

- Login to **Distributed Cloud Console**
- In Distributed Cloud Console, select **Multi-Cloud Network Connect**
- Navigate to **Manage > Site Management > Secure Mesh Sites v2**
- Select **Add Secure Mesh Site** to open the configuration form.
- In the **Metadata** section, enter a name for the site.
- Optionally, select labels and add a description.

**Step 2: Select the provider name as VMware.**

- Set the Provider Name option to VMware. Keep all other default values.
.. image:: ./assets/

- Click **Add Secure Mesh Site**

Download Node Image
--------------
VMWare uses OVA (Open Virtualization Appliance) file to store various files associated with a Virtual Machine (VM). This file is stored in the Open Virtualization Format (OVF) as a TAR archive.

F5 Distributed Cloud packages Customer Edge node software in an OVA template file that lets you add a pre-configured virtual machine to the vCenter Server or ESXi inventory. Using vApps properties of the OVA template, you can configure the Site and specify metadata, such as the node token required to register the CE Site nodes.

- Navigate to **Manage > Site Management > Secure Mesh Sites v2**
- From the Secure Mesh Sites page, for your site, click ... > **Download Image** and then save the image locally.
.. image:: ./assets/
- Ensure that you validate the **MD5SUM** of the image for an integrity check.
.. image:: ./assets/

Create Nodes (Virtual Machines)
--------------
Follow the steps below to deploy a CE node as a virtual machine (VM) using the OVA software image that was downloaded in the previous section.

**Generate Node Token**

A node token is required to register a CE Site node to the Distributed Cloud Console.

- In Distributed Cloud Console, select the **Multi-Cloud Network Connect** workspace
- Navigate to **Manage > Site Management > Secure Mesh Sites v2**
- For your site, click ... > **Generate Node Token**
.. image:: ./assets/
- Click Copy.
- Save the value locally. This token is used later. The token value is hidden for security purposes.
.. image:: ./assets/
- Click Close

**Create a CE Node (Virtual Machine)**

- SMSv2 CE VM will be created using the .ova image file downloaded earlier from F5 Distributed Cloud Console after creating site object.
.. image:: ./assets/
- Provide a new for VM and select the .ova file from the directory
.. image:: ./assets/
- Select “datastore” having sufficient space to run VM
.. image:: ./assets/
- In “Network”, interface port group having internet connectivity needs to be selected
.. image:: ./assets/
- Provide a hostname and paste the “Node token” obtainer earlier after creating site object
*Note: VM Network (OUTSIDE) port group selected in earlier step has DHCP enabled, so DHCP is marked as “yes” here, which will be default*
.. image:: ./assets/
- Review and click “Finish”
.. image:: ./assets/
- VM will boot-up and establish a connection with F5 Distributed Cloud for provisioning and registration. Once all the process is complete (usually it’ll take ~30 minutes) for the site to come up “Online” comprehensively
*Note: Site name is different in consecutive screenshots, please ignore this mismatch*
.. image:: ./assets/
- Select the site. The Dashboard tab should clearly show that the CE Site has registered successfully with the System Health of 100% as well as Data Plane/Control Plane both being up
.. image:: ./assets/

Creating New Port Group
--------------
Once the VM is up and online in F5 Distributed Cloud, we need to add internal local interface to communicate with Client VM locally, to achieve this new “Virtual switch” and “Port group” needs to be created.

- Create a “Virtual switch” by Navigating to “Networking” -> “Virtual switches” tab



