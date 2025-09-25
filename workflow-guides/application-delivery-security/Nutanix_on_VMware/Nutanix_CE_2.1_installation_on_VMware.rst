Installing Nutanix Community Edition 2.1 on VMware 
==========================================================================

Nutanix on VMware: 
***************
Nutanix is a unified platform to run applications and manage data across on-premises datacenters, public clouds. This helps in compute, storage, virtualization, and networking. In this documentation, we explain the steps to install Nutanix Community Edition (CE) on VMware ESXi.

Recommended Resources: 
***************
Below are the following resources requirements for running CE in our environment,

* Memory: 32 GB minimum, 64 GB or greater recommended  
* 4 CPU core minimum 
* 64 GB boot disk minimum 
* 200 GB Hot Tier Disk minimum for CVM 
* 500 GB Cold Tier Disk minimum for Data 

Reference page for `Recommended Hardware for Community Edition <https://portal.nutanix.com/page/documents/details?targetId=Nutanix-Community-Edition-Getting-Started-v2_1:top-sysreqs-ce-r.html>`__ section.  

Procedure to install Nutanix CE 2.1 on VMware: 
***************
Below are the series of steps to be followed to install CE on any VMware ESXi host, similar steps applicable for vSphere client as well. 

Make sure that you have a valid `Nutanix Community <https://next.nutanix.com/>`__ account, if not sign up to Nutanix `registration page <https://my.nutanix.com/page/signup>`__.  

1. Upload Image to datastore 
2. Create a virtual machine 
3. Install Nutanix CE 
4. Access the web console

**Step 1: Preparing installation media**

At first, we need to download the image from `Community Edition Discussion Form <https://next.nutanix.com/discussion-forum-14>`__ and click the Download Community Edition topic. Under Installer ISO, click the download link and Image gets downloaded to the local machine. 

Once the download is successful, Login to VMware ESXi host with credentials and navigate to Storage > Datastores, select the target datastore, open the Datastore browser, click Upload, and then select the ISO file from your local machine to begin the transfer.

.. figure:: Assets/vmware_login_page.jpg