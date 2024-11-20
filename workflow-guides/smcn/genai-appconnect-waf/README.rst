Connecting and securing distributed Generative AI applications with F5 XC AppConnect and XC WAF (hosted in AWS and Google Cloud)
================================================================================================================================


Overview
#########

This demo guide provides step-by-step walkthrough for connecting a distributed GenAI application (LLM hosted in AWS EKS and front-end GenAI application hosted in GCP's GKE) with F5's XC AppConnect and securing it with XC WAF, using XC console along with terraform scripts to automate the deployment. For more information on different WAAP deployment modes, refer to the devcentral article: `Deploy WAF on any Edge with F5 Distributed Cloud <https://community.f5.com/t5/technical-articles/deploy-waf-anywhere-with-f5-distributed-cloud/ta-p/313079>`__.

Setup Diagram
#############

.. figure:: assets/AppConnect-WAF.png

Workflow Instructions
######################

`F5 Distributed Cloud Console Workflow without NGINX Ingress Controller <./xc-console-demo-guide.rst>`__

`F5 Distributed Cloud Console Workflow (hybrid use case with NGINX Ingress Controller) <https://github.com/f5devcentral/f5-hybrid-security-architectures/blob/main/workflow-guides/smcn/hybrid-genai-appconnect-waf/xc-console-demo-guide.rst>`__

`F5 Distributed Cloud Console Automation Workflow without NGINX Ingress Controller <./automation-workflow.rst>`__

`F5 Distributed Cloud Console Automation Workflow (hybrid use case with NGINX Ingress Controller) <https://github.com/f5devcentral/f5-hybrid-security-architectures/blob/main/workflow-guides/smcn/hybrid-genai-appconnect-waf/automation-demo-guide.rst>`__


Additional Related Resources
############################
