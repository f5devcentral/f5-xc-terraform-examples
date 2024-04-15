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

The steps below explain deploying of F5 Distributed Cloud Services as a site/node in customer premises by deploying a virtual machine on VMware ESXi. 

1. Create Site Token & App Stack site object 
2. Deploy site on VMware ESXi
3. F5 XC configs and app deploy
4. Create Origin Pool & Load Balancer

Below we shall take a look into detailed steps,

1.   Create Site Token & App Stack Site object:
      **Step 1.1: Creating Site Token**
      - Login to F5 XC console home page and navigate to Multi-Cloud Network connect > Manage > Site Management > Site Token. Click “Add Site token”.
      - In the Name field, enter the token name and enter description. Click on Save and Exit.

      .. figure:: Assets/token_creation.jpg

      .. figure:: Assets/site-token-vmware.jpg


    