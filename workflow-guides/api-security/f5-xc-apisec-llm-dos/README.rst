Protect LLM applications against Model Denial of Service 
=============================


--------------

.. contents:: **Table of Contents**

Overview
#########

This demo guide provides step-by-step walkthrough for configuring API Security (Rate Limiting) for AI workloads in a multi-cloud (MCN) scenario. We will be using XC WAF on RE to protect against Model Denial of Service (OWASP LLM04 vulnerability) a Large Language Model application deployed on CE AppStack (managed Kubernetes) for distributed inference. This demo guide showcases a manual deployment using XC console along with the guide for the terraform scripts to automate it. For more information on different WAAP deployment modes, refer to the devcentral article: `Deploy WAF on any Edge with F5
Distributed Cloud <https://community.f5.com/t5/technical-articles/deploy-waf-on-any-edge-with-f5-distributed-cloud/ta-p/313079>`__.

**Note:** Even though the scenario here focuses on XC API Security, customers can enable any security services in the same setup, such as WAF, Bot Defense, DoS/DDOS and Fraud, as per their needs.

Setup Diagram
#############

.. figure:: assets/LLM_DoS_arch1.png

Workflow Instructions
######################

`F5 Distributed Cloud Console Workflow <./xc-console-demo-guide.rst>`__

`**Coming soon** F5 Distributed Cloud Automation Workflow <./automation-demo-guide.rst>`__

