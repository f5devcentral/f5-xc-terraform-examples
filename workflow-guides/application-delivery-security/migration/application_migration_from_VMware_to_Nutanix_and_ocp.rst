Migrating Application Traffic from VMware to Nutanix and OCP
#########################################################

Objective:
--------------
This document provides the step by step process to migrate the traffic from applicaiton running in VMware to load balance the traffic to apps among on Nutanix and OCP cloud platforms.

General Prerequisites:
--------------
Deployment of applicaiton on VMware using SMSv2 is covered in the document `F5 XC CE deploy on VMware using SMSv2 (SaaS Console) | F5 XC Solutions  <https://github.com/f5devcentral/f5-xc-terraform-examples/blob/main/workflow-guides/application-delivery-security/migration/application-migration-setup-vmware.rst>`__

Deployment of application on Nutanix platform using SMSv2 is covered in the document `F5 XC CE deploy on Nutanix using SMSv2 (SaaS Console) | F5 XC Solutions <https://github.com/f5devcentral/f5-xc-terraform-examples/blob/main/workflow-guides/smsv2-ce/Secure_Mesh_Site_v2_in_Nutanix/secure_mesh_site_v2_in_nutanix.rst>`__

Similarly, deployment of application on OCP platform using SMSv2 is covered in the document `F5 XC CE deploy on OCP using SMSv2 (SaaS console) <https://github.com/f5devcentral/f5-xc-terraform-examples/blob/main/workflow-guides/application-delivery-security/migration/application-migration-setup-ocp.rst>`__

Configuration steps:
--------------
Below are the steps should be followed to migrate the traffic from VMware to Nutanix and OCP

At first, we bring origin pools of Nutanix and OCP to the existing VMware load balancer.

.. image:: ./assets/mig_vmware_to_nutanix_op_add.jpg

.. image:: ./assets/mig_vmware_to_nutanix_add_op_to_lb.jpg

Click on Apply button.

Similarly, Add the OCP load balancer to the Origin pool.

Click on Pencil icon of VMware origin pool to update the weight to it.

.. image:: ./assets/mig_vmware_to_nutanix_ocp_weight_update.jpg

