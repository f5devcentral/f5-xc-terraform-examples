**Nutanix Deployment Steps:**
---------------
**Prerequisites:**
~~~~~~~~~~~~~~~~~~

- Nutanix CE cluster up and running.

- Should have BIG-IP VE image in QCOW2 format.

- Nutanix Image Service should be available.

- A configured virtual network (VLAN) in Nutanix CE.

**Deployment Steps:**
~~~~~~~~~~~~~~~~~~

**Download BIG-IP VE Image for AHV**


- Go to the F5 Downloads portal <https://downloads.f5.com>

- Login and Navigate to:

  - **BIG-IP Virtual Edition** and Select the version you want (e.g.,
    16.x, 17.x) :mark:`Note: 16.x is stable and recommended`

  - Choose Platform as KVM (since AHV supports QCOW2 images, same as
    KVM).

- Download the **QCOW2** image file (typically ends in .qcow2.zip or
  .qcow2.gz) and extract it.

**Upload Image to Nutanix CE**


- In Prism Element, go to:

  - Settings > Image Configuration (or just click on "Images" under the
    settings gear icon).

- Click and Add Image.

- | Provide the values for name, storage container and Image source and
    then click on save button.
  | |A screenshot of a computer AI-generated content may be incorrect.|

**Create the BIG-IP Virtual Machine**


- Go to VM from dropdown list and click on Create VM.

- | Provide the VM name, set CPU and Memory and Add the Disk:
  | |image1|
  | |image2|

- Add a Network Interface (NIC) and provide the required details and
  then click on **Save.
  **\ |image3|

- Add a Network Interface (NIC) and provide the required details and
  then click on **Save.
  **\ |image4|

- Finally click on Save button.

**Access the BIG-IP Web UI**


- Access the BIG-IP Web UI using a browse.

  - < https://ip_addr:8443/>

- Log in using the **admin** credentials configured during initial
  setup.

- Navigate to **System > License**.

- Choose either:

  - Manual Activation: Upload a license file provided by F5

  - Automatic Activation: Use an F5 license key with internet access.

- Select and provision the required software modules based on your
  license:

  - LTM (Local Traffic Manager)

  - ASM (Application Security Manager)

  - Advanced WAF, etc.

- Click Submit and allow the system to provision the selected modules.

- | Verify that the required modules have been provisioned correctly.
  | |image5|

.. |A screenshot of a computer AI-generated content may be incorrect.| image:: media/image1.png
   :width: 6.26806in
   :height: 3.30278in
.. |image1| image:: media/image2.png
   :width: 5.06748in
   :height: 6.24705in
.. |image2| image:: media/image3.png
   :width: 3.2026in
   :height: 3.7398in
.. |image3| image:: media/image4.png
   :width: 2.57737in
   :height: 2.74699in
.. |image4| image:: media/image4.png
   :width: 2.57737in
   :height: 2.74699in
.. |image5| image:: media/image5.png
   :width: 6.26806in
   :height: 3.55347in
