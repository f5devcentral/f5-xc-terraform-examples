**BIG-IP Deployment Steps in VMware:**
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Here is the topology diagram for this scenario.

|A diagram of a big-ip ve AI-generated content may be incorrect.|

- Create a virtual machine (VM) on VMware ESXi hosted on a Dell
  PowerEdge R640 bare-metal server and ensure the VM is booted using the
  BIG-IP OVA image downloaded from the MyF5 Downloads portal.

- Additionally, create two more virtual machines using Ubuntu ISO
  images—one to function as the client and the other as the server.

  - Deployment Steps<link>

**Prerequisites:**
~~~~~~~~~~~~~~~~~~

- VMware ESXi host UP and Running.

  - Access to the ESXi host via vSphere Client (web or desktop).

  - A virtual machine (VM) is created in VMware ESXi deployed in Dell
    PowerEdge-R640 bare metal.

- F5 BIG-IP virtual appliance image (usually in .ova or .ovf format).

  - The VM is booted using the OVA image of BIG-IP downloaded from myf5
    Downloads.

  - `Steps to download the latest BIG-IP
    image <https://f5-my.sharepoint.com/:w:/r/personal/sh_shaik_f5_com/Documents/Download%20BIG-IP%20Image.docx?d=wece5152f4ccb4a81a3693823e7a280df&csf=1&web=1&e=EVbaun>`__

- Licensing info for BIG-IP if applicable.

**Deployment Steps:**

1. **Log in to VMware ESXi:**

- Open your web browser and navigate to the VMware ESXi host IP address.

- Enter your administrative credentials to access the ESXi management
  interface.

2. **Start the VM Creation Process:**

- In the left-hand navigation pane, select **Virtual Machines**.

- | Click on the **Create / Register VM** button at the top.
  | |A screenshot of a computer AI-generated content may be incorrect.|

3. **Select Deployment Type**

- In the wizard, choose **Deploy a virtual machine from an OVF or OVA
  file**.

- | Click **Next** to proceed.
  | |image1|

4. **Specify VM Name and Upload OVA**

- Enter a descriptive and unique name for your BIG-IP virtual machine.

- Upload the BIG-IP OVA file by dragging and dropping it into the
  designated area or by browsing your local files. <need to check>

  - Steps to download BIG-IP OVA file:

    - Visit the `F5 Downloads <https://my.f5.com/manage/s/downloads>`__
      page and then log in with your credentials.

    - After logging in, look for **BIG-IP Virtual Editions (VE)**.

    - You can find this under **Products > BIG-IP Virtual Editions** or
      search directly for "BIG-IP Virtual Edition OVA".

    - Choose the BIG-IP version you want to deploy (e.g., 17.x, 16.x).

    - Locate the OVA package (it may be bundled with other files like
      license or documentation).

    - Click **Download** to get the OVA file to your local machine.

- | Once the OVA file is selected, click **Next**.
  | |image2|

5. **Choose Datastore**

- Select the datastore where you want to store the VM configuration
  files and virtual disks.

- Ensure the selected datastore has sufficient storage space and
  appropriate performance characteristics.

- Click **Next**.

6. **Accept License Agreement**

- Review the end-user license agreement (EULA) presented by the BIG-IP
  OVA package.

- Click **I Agree** to accept the terms.

- Click **Next** to continue.

7. **Configure Network Mappings and Deployment Options**

- Map the BIG-IP virtual machine’s network interfaces to the appropriate
  virtual switches or port groups available on your ESXi host.

- Choose the deployment format as **Thin provisioned** for
  storage-efficient disks.

- | Confirm your selections and click **Next**.
  | |image3|

8. **Review and Confirm**

- Carefully review all deployment settings, including VM name,
  datastore, network mappings, and provisioning options.

- | If everything looks correct, click **Finish** to start the
    deployment.
  | |image4|

9. **Power On and Initial Configuration**

- Once deployment completes, locate the VM in the **Virtual Machines**
  list.

- Right-click the VM and select **Power > Power On**.

- Open the VM console to monitor the boot process.

10. **Obtain the BIG-IP Management IP Address ,connect and perform
    licensing.**

- | Use the VM console in VMware ESXi or check your DHCP server to find
    the management IP assigned to the BIG-IP virtual machine.
  | |image5|

- Alternatively, if you configured a static IP during deployment, use
  that address.

- From your local machine, open a terminal or SSH client and then
  connect using the default root credential like <**ssh
  root@<BIG-IP-management-IP**>>

- When prompted, enter the default password (commonly **default**).

- Immediately after login, change the default root password to a strong,
  secure password to protect your system.

- Use the BIG-IP command line interface to update the admin user
  credentials.

- This is critical for secure access to the BIG-IP management web
  interface.

- **Activate the BIG-IP license**
  Choose either:

  - Manual Activation: Upload a license file provided by F5

  - Automatic Activation: Use an F5 license key with internet access.

- Select and provision the required software modules based on your
  license:

  - LTM (Local Traffic Manager)

  - ASM (Application Security Manager)

  - Advanced WAF, etc.

- Click Submit and allow the system to provision the selected modules.

- | Once license is uploaded successfully go back to the BIG-IP GUI >
    System > License and cross verify the required modules are
    provisioned or not.
  | |image6|

- Finally, set the hostname, DNS server, and NTP settings if required.

.. |A diagram of a big-ip ve AI-generated content may be incorrect.| image:: media/image1.png
   :width: 6.26806in
   :height: 3.47153in
.. |A screenshot of a computer AI-generated content may be incorrect.| image:: media/image2.png
   :width: 6.26806in
   :height: 1.66667in
.. |image1| image:: media/image3.png
   :width: 6.26806in
   :height: 3.91597in
.. |image2| image:: media/image4.png
   :width: 6.26806in
   :height: 3.94375in
.. |image3| image:: media/image5.png
   :width: 6.26806in
   :height: 3.99375in
.. |image4| image:: media/image6.png
   :width: 6.26806in
   :height: 3.9625in
.. |image5| image:: media/image7.png
   :width: 6.26806in
   :height: 2.41667in
.. |image6| image:: media/image8.png
   :width: 6.26806in
   :height: 3.36042in
