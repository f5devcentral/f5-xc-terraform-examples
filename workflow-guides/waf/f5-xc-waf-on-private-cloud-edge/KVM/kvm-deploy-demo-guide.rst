Deploying F5 XC’s Customer Edge using KVM on Openstack’s Private Cloud 
==========================================================================


Introduction
***************

As there is a drastic change in deploying application from traditional data centers to the Hybrid Cloud in recent times. Companies are deploying their apps in the environment that made the most sense for the applications. Hence there is a greater demand in distribution of applications in multiple public cloud, traditional data centers, Private cloud, and edge as well.  

There are certain apps that are residing in environment (like private cloud) needs to be connected to other environment such as multi-cloud networking platforms for better transit of data with greater security measures along with low latency and this can be achieved using F5 Distributed Cloud (F5 XC). 

Solution overview
*******************

In this article, we demonstrate deploying F5 XC Services site as a Customer Edge (CE) on KVM in Open Stack private cloud network. We also deploy an application and connect the CE to the F5 XC’s Global network. This results in extending the F5 XC’s global backbone network to the customer premises to provide security capabilities along with telemetry. 

.. figure:: Assets/KVM_on-prem_new.jpeg

Prerequisites
**************
- Distributed Cloud Console SaaS account.
- Access to Openstack Management console & Command Line
- Install Kubectl command line tool to connect and push the app manifest file to CE
- Install postman for verifying the deployment

Step by Step procedure
************************

F5 XC services support site deployment for a Kernel-based Virtual Machine (KVM) as a node and to perform site registration on F5 XC console. Below are the steps mentioned,

1. Deploy CE on OpenStack
2. Configure CE site
3. F5 XC configs and app deploy 
4. Create Origin Pool & Load Balancer

Below we shall take a look into detailed steps as mentioned,

1.   Deploy CE on OpenStack:
      **Step 1.1: Creating Site Token**
      
      Login to F5 XC console home page and navigate to Multi-Cloud Network connect > Manage > Site Management > Site Token. Click “Add Site token” and create a site token.
      
      .. figure:: Assets/site-token-creation.jpg

      **Step 1.2: Deploying CE on Openstack**
      
      Creating an instance in Open Stack with the the KVM image file: rhel-9.2023.29-20231212011947. Resources allocated to this instance are 8 vCPUs and 16 GB RAM. Minimum resources required for node deployment are mentioned `here <https://docs.cloud.f5.com/docs/how-to/site-management/create-kvm-libvirt-site>`__. 

      .. figure:: Assets/open-stack.jpg

      * Login to CE site created above with credentials as admin/Volterra123 and must change password during first login as mentioned below,

      .. figure:: Assets/open-stack-login.jpg

2.   Configure the CE site
      **Step 2.1: Configuring Network configuration of CE**

      Provide the network configurations for the CE site as mentioned below according to the requirement,

      - Select certificate hardware as ``kvm-voltmesh``.
      - Select primary outside NIC as ``eth0``.
      - Dhcp enabling, wifi configs, VoltADN private configs were set as No.
      - Static IP configs and HTTP_Proxy were not required for now.
      - NTP1 and NTP2 addresses were set to empty.

      .. figure:: Assets/configure-network-new-2.jpg

      Enter Y to confirm configuration.

      **Step 2.2: Providing node configurations**

      - Provide the site token created in above step from F5 XC console.
      - Enter the name of the site and hostname.
      - Enter the latitude and longitude of the CE site location.
      - Select certificate hardware as ``kvm-voltmesh``. 
      - Select primary outside NIC as ``etho``.
      - Select registration env as blank.

      .. figure:: Assets/node-configs.jpg

      Enter Y to confirm configuration.

      **Step 2.3: Registration of CE site**

      After the Distributed Cloud Services Node is installed, it must be registered as a site in F5 XC console.

      - Login to F5 XC console. Click on Multi-Cloud Network Connect. Click Manage > Site Management > Registration.
      - Under pending Registration, look for node name and then click on blue checkmark.

      .. figure:: Assets/pending-registration.jpg

      - Verify the configs & enter other configurations, if needed.

      .. figure:: Assets/approve-registration.jpg

      - Click on Save and Exit to complete site registration.


      .. figure:: Assets/online-state.jpg

      Confirm site deployed and online by navigating to Multi-Cloud Network Connect > Sites.

      - It takes a few minutes for the site to come to online state along with OS version, SW version section values shows successful.


      .. figure:: Assets/site-status-online.jpg

3.   F5 XC configs and app deploy
      **Step 3.1: Creating & Assigning labels to Site**

      - From F5 XC console > select Shared Configuration box.
      - Select Manage in left-menu > select Labels > Known Keys and select “Add known key” button.

      .. figure:: Assets/labels.jpg

      - Enter Label key name and value for the key. Click on “Add key button” to create key-value pair.

      - Navigating to Multi-Cloud Network Connect > Site Management > App Stack Sites. Select the site to which labels need to be assigned and click on Manage Configuration.

      .. figure:: Assets/manage-configs.jpg

      - Click on Edit configuration on the top right corner to make config changes to the site.

      - Click on Add Label in Labels section and add the key-value pair created above.

      .. figure:: Assets/labels-to-site.jpg

      - Click on Save and Exit.

      **Step 3.2: Creating Virtual Site & vK8s object**

      - From F5 XC Console homepage, Click on Shared Configuration. Click Manage > Virtual Sites and click on “Add Virtual Site”.
      - In the Site Type select CE. From the Selector Expression field, click Add Label to provide the custom key created previously along with operator, followed by custom value as shown below. Click on Save and Exit.

      .. figure:: Assets/virtual-site-creation.jpg

      - From F5 XC Console Homepage, Select Distributed apps. Select Applications > Virtual k8s. Click on “Add Virtual K8s” to create a vK8s object.
      - In the Virtual Sites section, select Add item and then select a virtual site created above from the drop-down menu.

      .. figure:: Assets/vk8s-object.jpg

      - Deploy the application on VMware EXSi using the kubeconfig file for the vK8s object created above.

      .. figure:: Assets/app-deploy.jpg

      - Application is deployed successfully.

4.   Creating Origin Pool and Load Balancer
      **Step 4.1: Creating Origin Pool **

      - Creating an origin pool for application deployed in private cloud on the CE site.

      .. figure:: Assets/op-configs.jpg

      - Created a Load balancer and assigned Origin Pool to the Load Balancer to access the application.

      .. figure:: Assets/lb-configs.jpg

      - Application is accessible.

      .. figure:: Assets/app-accessing.jpg
      
      Created a WAF policy with enforcement mode as blocking and assigned this to the Load Balancer.

      .. figure:: Assets/waf-policy.jpg

      - Able to see request getting blocked for accessing file type violation.

      .. figure:: Assets/block-request.jpg


Conclusion
**************
F5 XC supports deploying its services across different private cloud platforms like openstack, this helps to connect its applications running in then to the F5 XC global network and protect the application. This gives feasibility to the organizations to utilize the services running across different cloud platforms in an easy manner.

Additional Links
******************
https://docs.cloud.f5.com/docs/how-to/site-management/create-kvm-libvirt-site


















