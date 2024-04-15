Deploying F5 XC’s Customer Edge using ESXi on VMware Private Cloud Edge
==========================================================================

Introduction
***************
F5 Distributed Cloud (F5 XC) supports deploying its services as a node in VMware environment. This helps to connect services/applications running on VMware based on-premises environment to F5 XC Global Network and deliver consistent security.

This expands application deployed in VMware to connect across services running in multiple public cloud platforms. 

Solution overview
*******************
In this article, we demonstrate deploying F5 XC services as a Customer Edge (CE) on VMware ESXi hypervisor and connect the CE to the F5 XC’s Global network. We also deploy a dummy Flight booking application designed to book flights.  

.. figure:: Assets/VMware_ESXi.jpeg

Prerequisites
**************
- Distributed Cloud Console SaaS account.
- Access to VMware ESXi Host Client
- Install Kubectl command line tool to connect and push the app manifest file to CE
- Install postman for verifying the deployment

Step by Step procedure
************************

The steps below explain deploying of F5 XC Services as a site/node in customer premises by deploying a virtual machine on VMware ESXi. 

1. Create Site Token & App Stack site object 
2. Deploy site on VMware ESXi
3. F5 XC configs and app deploy
4. Create Origin Pool & Load Balancer

Below we shall take a look into detailed steps,

1.   Create Site Token & App Stack Site object:
      **Step 1.1: Creating Site Token**
      - Login to F5 XC console home page and navigate to Multi-Cloud Network connect > Manage > Site Management > Site Token. Click ``Add Site token``.
      - In the Name field, enter the token name and enter description. Click on Save and Exit.

      .. figure:: Assets/token_creation.jpg

      .. figure:: Assets/site-token-vmware.jpg

      **Step 1.2: Creating App Stack Site Object**   

      - From F5 XC Console homepage, Select Multi-Cloud Network Connect and navigate to Manage > Site Management > App Stack Sites.
      - Click on Add App Stack Site to open site configuration form.
 
      .. figure:: Assets/site-creation.jpg

      - Provide a name in the Metadata section. Under basic configuration section, From the Generic Server Certificate Hardware menu, select ``vmware-voltstack-combo``. 
      - Enter the name of the master node as ``master-0`` in Master Nodes section.
      - Provide the coordinates: Latitude and longitude of the VMware site. Click on Save and Exit.

      .. figure:: Assets/site-configuration.jpg

      - After creating the App Stack site object, the site status shows as Waiting for Registration.

      .. figure:: Assets/wait-fr-register.jpg


2.   Deploy Site on VMware ESXi:
      **Step 2.1: Install the Node on VMware ESXi Hypervisor**

      Login to VMware ESXi portal.

      .. figure:: Assets/vmware-login.jpg

      - Click on Create/Register VM from Virtual Machines section.

      .. figure:: Assets/create-vm.jpg

      - Select Deploy a virtual machine from an OVF or OVA file from the options listed and click on Next.

      .. figure:: Assets/ova-ovf.jpg

      - Enter Virtual Machine name and click to select the OVA file to boot the VM. Click on Next.

      - F5 XC Services VMware OVA file can be downloaded by going to this `link <https://docs.cloud.f5.com/docs/images/node-vmware-images#vmware-images>`__.

      .. figure:: Assets/vs-name_image.jpg
      
      - Select the storage as required based on the storage available on the hypervisor host. Click on Next.

      .. figure:: Assets/storage-vmware.jpg

      - Select the Network to which VM should be connected to. Disk provisioning is set to thin provisioning as default. Click on Next.

      .. figure:: Assets/network-vmware.jpg

      These parameters enable the machine to request registration directly to the F5 XC console.

      - Provide Hostname as ``master-0`` which should be same as Node name mentioned in step 1.2
      - Enter the token created in step 1.1 
      - Enter the Admin password and re-enter in Admin password confirm field.
      - Set the cluster name as ``chthonda-vmware-sjc`` which should be same as App Stack Site object name created in step 1.2
      - Scroll down to Enter Certificate Hardware as ``vmware-voltstack-combo``.
      - Enter latitude and longitude of the VMware site. Click on Next.

      .. figure:: Assets/additional_settings-new.jpg

      .. figure:: Assets/additional_settings-2.jpg

      - Click on Finish to boot the VM with uploaded OVA file.

      .. figure:: Assets/wizard-configs.jpg
      
      virtual machine is built and booted.

      **Step 2.2: Register the VMware site**

      After the Distributed Cloud Services Node is installed in VMware, it must be registered as a site in F5 XC Console.

- hello there









    