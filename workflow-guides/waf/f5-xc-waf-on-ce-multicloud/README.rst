Deploying F5 XC WAF on Customer Edge (Multi-Cloud Scenario)
-------------------------------------------------------------

**Overview**
#############

This demo guide provides manual step-by-step walkthrough for applying WAF on CE sites deployed on different cloud platforms and establishing connectivity among them using XC console, along with terraform scripts to automate the deployments. For more information on different WAAP deployment modes, refer to the devcentral article: `Deploy WAF Anywhere with F5
Distributed Cloud <https://community.f5.com/t5/technical-articles/deploy-waf-anywhere-with-f5-distributed-cloud/ta-p/313079>`__.

**Note:** Even though the scenario here focuses on XC WAF, customers can enable any security services in the same setup, such as API Security, Bot Defense, DoS/DDOS and Fraud, as per their needs.

This use-case is divided into 2 sub parts:
  1. Multi-Cloud Networking (MCN) without Site Mesh Group(SMG)
  2. Multi-Cloud Networking (MCN) with Site Mesh Group(SMG)

**Multi-Cloud Networking (MCN) without Site Mesh Group(SMG)**
###############################################################

Setup Diagram
***************


.. figure:: MCN-without-SMG/assets/readme.jpeg

Workflow Instructions
***********************


`F5 Distributed Cloud Console Workflow <MCN-without-SMG/xc-console-demo-guide.rst>`__

`F5 Distributed Cloud Automation Workflow <https://github.com/f5devcentral/f5-xc-terraform-examples/tree/main/workflow-guides/smcn/app-delivery-fabric/terraform>`__

**Multi-Cloud Networking (MCN) with Site Mesh Group(SMG)**
###########################################################

Setup Diagram
***************


.. figure:: MCN-with-SMG/assets/readme.jpeg

Workflow Instructions
***********************


`F5 Distributed Cloud Console Workflow <MCN-with-SMG/xc-console-demo-guide.rst>`__

`F5 Distributed Cloud Automation Workflow <https://github.com/f5devcentral/f5-xc-terraform-examples/blob/main/workflow-guides/waf/f5-xc-waf-on-ce-multicloud/MCN-with-SMG/>`__


