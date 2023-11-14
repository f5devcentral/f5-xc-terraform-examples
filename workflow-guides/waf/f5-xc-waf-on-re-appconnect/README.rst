Deploying F5 XC WAF on RE + AppConnect
--------------

.. contents:: Table of Contents

Overview
#########
This guide provides detailed manual configuration steps for WAF (on RE )+ App Connect scenarios along with the terraform scripts to automate the deployment which helps users in configuring CE (Customer Edge) sites, connect the application which is not accessible from the internet and access it securely using F5 Distributed Cloud. For more details on WAF series, please refer to  `Deploy WAF Anywhere Overview Article <https://community.f5.com/t5/technical-articles/deploy-waap-anywhere-with-f5-distributed-cloud/ta-p/313079>`_

Below two scenarios of deploying application in different resources are covered in thie guide.

1. Deploy application in Virtual Machine.

2. Deploy application in Kubernetes Cluster.

**Note**: Automation scripts and steps will be attached soon. Even though the scenario here focuses on XC WAF, customers can enable any security services in the same setup, such as API Security, Bot Defense, DoS/DDOS and Fraud, as per their needs.

Setup Diagram
#############
Below are the workflow diagrams for two different usecases depending on the way the application is deployed in backend:

**Workflow Representation when application is deployed in Azure VM:**

.. figure:: assets/WAAP-on-RE-AppConnect-vm.png

**Workflow Representation when application is deployed in Azure Kubernetes Cluster:**

.. figure:: assets/WAAP-on-RE-AppConnect-K8s .png

Workflow Instructions
######################

`F5 Distributed Cloud Console Workflow <./xc-console-demo-guide.rst>`__

`F5 Distributed Cloud Automation Workflow <./automation-demo-guide.rst>`__
