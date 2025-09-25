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

**Step 1: Uploading Image to datastore**

At first, we need to download the image from `Community Edition Discussion Form <https://next.nutanix.com/discussion-forum-14>`__ and click the Download Community Edition topic. Under Installer ISO, click the download link and Image gets downloaded to the local machine. 

Once the download is successful, Login to VMware ESXi host with credentials and navigate to Storage > Datastores, select the target datastore, open the Datastore browser, click Upload, and then select the ISO file from your local machine to begin the transfer.

.. figure:: Assets/vmware_login_page.jpg

.. figure:: Assets/image_upload.jpg  

Once the upload is complete, refresh the Datastore Browser to see the uploaded ISO file. 

.. figure:: Assets/ce_image_upload_success.jpg  


**Step 2: Creating a virtual machine**

Below are the steps to create a virtual machine with Nutanix CE ISO uploaded to VMware ESXi machine, 

* From the ESXi login, click the Create/Register VM button.

.. figure:: Assets/create-register-vm.jpg  

* Click on create a new virtual machine and click next.

.. figure:: Assets/create-vm.jpg  

* Enter a valid name for your virtual machine. 
* Select the appropriate compatibility for your environment, I have selected ESXi 6.7 virtual machine. 
* Choose Guest OS family as Linux. 
* Select guest OS version as Centos 7 (64-bit) or above. I have selected Centos 8 (64-bit). Click on Next. 

.. figure:: Assets/vm-creation-guest-os.jpg  

* From the Select Storage, choose the datastore where the virtual machine’s configuration and disk files will be stored. Click on Next. 

.. figure:: Assets/vm-creation-storage-selection.jpg  

* On the following screen of customize settings, CPU, Memory, hard disks as mentioned in Recommended Resource section above. Click on “Add hard disk” button to add additional Hard disk for CVM and data.
* I have selected CPU as 4, Memory is 32, 3 hard disk with 64 GB, 200 GB, 500 GB each. 
* Select the Network Adapter 1 as Network that has internet connectivity. In my case, my network is “VM Network”.

.. figure:: Assets/vm-creation-customize-settings-1.jpg  

* Scroll down a bit and hover over to CD/DVD Drive 1 and select Datastore ISO file from the dropdown menu. 

.. figure:: Assets/vm-creation-cd-dvd-selection.jpg

* Select the ISO file that was uploaded at step 1. 

.. figure:: Assets/vm-creation-image-selection.jpg

.. figure:: Assets/vm-creation-image-uploaded.jpg

* Click on VM options to add disk.EnableUUID=TRUE in the VMX file manually. This is needed to get the disk serials populated during Nutanix bootup process. 

.. figure:: Assets/vm-creation-customize-settings-vmoptions.jpg


.. figure:: Assets/vm-creation-vm-edit-configs.jpg

* Under the Advanced section, Click on Edit Configuration.
* Scroll down to the bottom and Click on Add Parameter, you can able to see Click to edit key and click to edit value. 

.. figure:: Assets/vm-creation-vm-option-app-parameters-2.jpg

* Enter the key as disk.EnableUUID and value as TRUE. 

.. figure:: Assets/vm-creation-vm-option-app-parameters-key-value.jpg

* Click on okay.

.. figure:: Assets/vm-creation-save-configs.jpg

* Click on Save.  
* Click on Power on to switch on the virtual machine. 

.. figure:: Assets/vm-creation-power-on.jpg

Once instance is powered on, click on console to access the instance for CE installation. 
.. figure:: Assets/vm-creation-console-access.jpg

Logs show the installation on Nutanix CE and take couple of minutes to get to installer screen. 

**Note:** Make sure you set Promiscuous mode, MAC address changes, Forged transmit to Accept in virtual switch settings, 

.. figure:: Assets/virtual_switch_config_promiscuous_mode.jpg


**Step 3: Installing Nutanix CE on VMware**
    **Step 3.1: Installing CE on VMware**
    Below are the steps gives detailed steps to configure single node cluster on VMware ESXi. 
    Before proceeding for the installation, make sure you have a list of IP-Addresses available on your own LAN, 

    * 2 IP addresses for AHV and CVM
    * 1 IP address for cluster 
    * Gateway and Netmask address details 

    These IP addresses should be on the same network as where your machine is available in. We are going to use the bridge network functionality from VMware ESXi so that AHV, CVM and cluster IP are available on your network.

    I have configured my setup details as below,

        * 10.144.126.61, 10.144.125.62 for AHV and CVM 
        * 10.144.126.63 for Cluster IP 
        * 10.144.126.254 and 255.255.255.0 as Gateway and Netmask 

    Installer screen logs shown as below, 

    .. figure:: Assets/ce-install.jpg
    
    When the boot sequence finishes, the CE installer dialog appears,

    .. figure:: Assets/ce-install-dialog.jpg

    In the screenshot mentioned above, Hypervisor selection is AHV, and Hard disks were selected for CVM boot disk and others as Data disk. Use Tab to navigate to the Disk Selection field.  
    
    Use the up arrow and down arrow keys to navigate between the disk selection, use C to confirm the CVM boot disk, H to confirm the hypervisor boot disk selection, Similarly D for Data Disk. 
    
    Provide the networking information such as Host IP address, CVM IP Address, Subnet Mask and Gateway that you gathered. 
    
    Press Tab to select Next Page and press Enter. 

    Read the end-user license agreement (EULA). Use the up arrow and down arrow keys to scroll. Press Tab to navigate to the I accept the end user license agreement checkbox.

    .. figure:: Assets/eula-license-aggrement.jpg

    Press the spacebar to select the checkbox. Use the arrow keys to navigate to Start and press Enter to start the installation process. 

    Installation process as follows, 

    .. figure:: Assets/ce-install-process-1.jpg

    .. figure:: Assets/ce-install-process-2.jpg

    .. figure:: Assets/ce-install-process-3.jpg
    
    Before proceeding to the bootup, need to initiate the boot sequence from AHV virtual disk, to get it done, we are going to disable the CD/DVD drive 1 from which initial boot sequence was initiated. 

    * Disabled Connect at power on checkbox. 
    
    .. figure:: Assets/ce-install-disable-power-on.jpg
    
    * A pop up shows, ejecting the CD-ROM to initiate the bootup process, 

    * Click on Yes and click on Answer. 

    .. figure:: Assets/ce-install-dialog-answer.jpg

    * Enter the Y key and press Enter. 

    .. figure:: Assets/ce-install-enable-y.jpg
    
    Now the VM will be booted with AHV. 

    .. figure:: Assets/nutanix_ce_install.jpg

    **Step 3.2: Creating and configuring single node cluster**

    



    