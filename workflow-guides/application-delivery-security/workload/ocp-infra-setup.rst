Red Hat OpenShift Container Platform (OCP) Setup on VMware
#########################################################

Creating Cluster from Red Hat Console:
--------------
1. Login to Red Hat Hybrid Cloud Console using the link(https://console.redhat.com)

    *Note: Valid account having subscription is required to create OpenShift Cluster*

2. Select “Red Hat OpenShift” widget

3. Click “Dashboard” in the left menu and click on “Create cluster”

.. image:: ./assets/assets-ocp-infra/1.png

4. Select “Datacenter” column and click on “Create cluster” under Assisted Installer

.. image:: ./assets/assets-ocp-infra/2.png

5. Enter details of the cluster in Section 1

.. image:: ./assets/assets-ocp-infra/3.png

6. Select “control plane nodes” and “network configuration” and click “Next”
    *Note1: For deploying CE in OCP cluster, 3 nodes are recommended*
    *Note2: For this demo we’re going with 1 Node and Static IP*

.. image:: ./assets/assets-ocp-infra/4.png

7. In Section 2, provide DNS, Machine network and Default gateway and click “Next”

    *Note: If you’re not sure, please get these details from your network team and don’t use the below details as it is in screenshot*

.. image:: ./assets/assets-ocp-infra/5.png

8. Provide Host MAC Adress and IPv4 address and click “Next”

    *Note: For more than 1 nodes, you need to provide MAC and IPv4 address for all hosts*

.. image:: ./assets/assets-ocp-infra/6.png

9. Under the “Operators” section, click “Next”

    *Note: For more than 1 node, select “Virtualization” and proceed*

.. image:: ./assets/assets-ocp-infra/7.png

10. Under “Host discovery” section, click “Add host”

.. image:: ./assets/assets-ocp-infra/8.png

11. Provide SSH key (optional) and click “Generate Discovery ISO”

.. image:: ./assets/assets-ocp-infra/9.png

12. Click “Download Discovery ISO”, ISO (size ~125MB) download will start

.. image:: ./assets/assets-ocp-infra/10.png

13. Now navigate to ESXi and create a VM with required specifications based on requirement.
In this demo below specs are used:
    1. CPU -> 9 (Hardware virtualization should be enabled)

    .. image:: ./assets/assets-ocp-infra/11.png

    2. Memory -> 32 GB RAM
    3. Hard disk 1 -> 200 GB (Screenshots shows 100GB, recommended to use 200 GB as Client VM also needs to be installed)
    4. Network Adapter 1 -> Default VM Network with MAC Address set to the one defined earlier while creating cluster in step 8
    5. CD/DVD Drive 1 -> Select “Datastore ISO file”, where OCP ISO file downloaded should be uploaded and used for VM. Enable “Connect at power on”

    .. image:: ./assets/assets-ocp-infra/12.png

    6. VM Options -> Advanced -> Edit Configurations -> Add parameter
        - key -> disk.enableUUID
        - value -> TRUE

    .. image:: ./assets/assets-ocp-infra/13.png

    7. Click ”Next” and Finish to complete the configuration of VM
    8. “Power on” the VM

14. Once the VM starts booting, wait for some time (~2 minutes), the VM will be visible in “Host discovery” in Red Hat console with MAC Address as hostname.

    *Note: If more than 1 node is selected, wait for all the nodes to discover and select role*

.. image:: ./assets/assets-ocp-infra/14.png

15. Click “Next” and under “Storage” section also click “Next”

.. image:: ./assets/assets-ocp-infra/15.png

16. Verify “Networking”

    *Note: If more than 1 node, IPv4 address for API and Ingress need to be provided in this section*

.. image:: ./assets/assets-ocp-infra/16.png

17. Review configuration and click “Install cluster”

.. image:: ./assets/assets-ocp-infra/17.png

18. Installation will start

.. image:: ./assets/assets-ocp-infra/18.png

19. It’ll take around ~1 hour to complete.

After **Installation completed successfully**, make a note of the console login credentials available under “Web Console URL”

.. image:: ./assets/assets-ocp-infra/19.png

20. To access the cluster console, URL needs to be resolved by configuring in hosts file.
Click “Not able to access the Web Console” and copy-paste the configuration to hosts file.

.. image:: ./assets/assets-ocp-infra/20.png

21. Along with those URL mentioned, include *cdi-uploadproxy* URL as well which is required for uploading images in OCP cluster

.. image:: ./assets/assets-ocp-infra/21.png

22. Once the hosts file configuration is saved, access the “Web console URL”, click “Accept risk and continue”, you’ll land on cluster login page. Credentials for login are available in step 19.

.. image:: ./assets/assets-ocp-infra/22.png

23. After login, verify the Nodes, CPU, Memory and Filesystem.

    *Note: To access the cluster from CLI, navigate to “Copy login command” under "kube:admin”*

.. image:: ./assets/assets-ocp-infra/23.png

.. image:: ./assets/assets-ocp-infra/24.png

.. image:: ./assets/assets-ocp-infra/25.png

Commands to install OC
--------------
curl -LO https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz

tar -xvf openshift-client-linux.tar.gz

sudo mv oc /usr/local/bin/

