Deploying F5 Distributed Cloud Customer Edge Site on a Bare Metal Hardware in Private Cloud Network
==========================================================================

Introduction
***************
F5 Distributed Cloud (F5 XC) supports deploying its services as a node on bare metal hardware. This capability allows services and applications running on bare metal to connect seamlessly to the F5 XC Global Network, ensuring consistent delivery, security, and performance across diverse distributed infrastructure.

By installing the F5 XC ISO image on bare metal hardware, you can configure it as a Customer Edge (CE) site. This setup helps redirect traffic from the Regional Edge (RE) to the applications deployed behind the CE, providing enhanced security and optimized traffic management. This approach ensures that applications benefit from the robust security features and performance enhancements offered by the F5 XC platform.

.. figure:: Assets/Baremetal_ce_topo.jpeg

Prerequisites
**************
- Access to Distributed Cloud Console SaaS account. 
- Access to any bare metal hardware.
- Install Kubectl command line tool to connect and push the app manifest file to CE. 
- Install postman/web browser to verifying the deployment. 

Step by Step procedure
************************

The steps below explain deploying of F5 XC Services as a site/node in bare metal. 

1. Boot the Hardware with ISO image 
2. Create Site Token and App Stack site object 
3. Configure CE site 
4. F5 XC configs and app deploy 
5. Create Origin Pool & Load Balancer 

Step 1: Booting the Hardware with ISO image
        Download the F5 XC ISO file by going to this link. 

        As part of this demo, I am going to deploy this image on Dell iDRAC 9 with INTEL NIC that supports F5 XC ISO deployment. 

        As a prerequisite, make sure the NIC such as Intel, Red Hat, VMware with drivers such as “hv_netvsc, ena, ixgbe, ixgbe_isv, ixgbevf, e1000e, igb, i40e, e1000, vmxnet3, virtio_net, ice, iavf ” are available. Since they are supported to deploy ISO image. 
        More information on supported hardware details can be found by going to this link.
        - Obtain the IP address and log in to the device in which you want to deploy ISO image. 

        .. figure:: Assets/dell_login.jpg


