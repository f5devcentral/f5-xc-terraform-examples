Deploying F5 XC WAF on RE + AppConnect in Kubernetes Cluster
--------------

.. contents:: Table of Contents

Overview
#########
This guide provides detailed manual steps along with the terraform scripts to automate the deployment for WAF (on RE)+ AppConnect scenario in which application is deployed in Kubernetes Cluster. This helps users in configuring CE (Customer Edge) sites, connect the application which is not accessible from the internet and access it securely using F5 Distributed Cloud. For more details on WAF series, please refer to  `Deploy WAF Anywhere Overview Article <https://community.f5.com/t5/technical-articles/deploy-waap-anywhere-with-f5-distributed-cloud/ta-p/313079>`_

**Note**: Automation scripts and steps will be attached soon. Even though the scenario here focuses on XC WAF, customers can enable any security services in the same setup, such as API Security, Bot Defense, DoS/DDOS and Fraud, as per their needs.

Setup Diagram
#############

.. figure:: assets/WAAP-on-RE-AppConnect-K8s .png

Workflow Instructions
######################

`F5 Distributed Cloud Console Workflow <./k8s-manual-demo-guide.rst>`__

`F5 Distributed Cloud K8s Automation Workflow <./k8s-automation-demo-guide.rst>`__

If you want to deploy application in Virtual Machine, please refer to `VM Workflow Guide <https://github.com/f5devcentral/f5-xc-waap-terraform-examples/blob/main/workflow-guides/waf/f5-xc-waf-on-re-appconnect/vm/README.rst>`__
