F5 Distributed Cloud WAF deployment on k8s
===========================================

Introduction :
---------------
WAAP is a set of security services which protects applications from known application threats thereby providing WAF, DDOS prevention, API Security and bot mitigation solution. To safeguard our modern applications which are residing inside a k8s cluster, we have to integrate this solution as part of data plane workflow. In this article we are going to provide a possible solution for deploying WAF in the customer existing k8s infra using F5 XC. 

Use this repo configuration files and work-flow guides for deploying WAF on Kubernetes. Please check `Deploy WAF Overview
article <https://community.f5.com/t5/technical-articles/deploy-waap-anywhere-with-f5-distributed-cloud/ta-p/313079>`__
or `WAF on k8s
article <https://community.f5.com/t5/technical-articles/deploying-f5-distributed-cloud-waap-on-kubernetes/ta-p/317324>`__
for more details.

Architectural diagram :
------------------------
.. image:: /workflow-guides/waf/f5-xc-waf-on-k8s/assets/MicrosoftTeams-image.png


Deployment Diagram :
-----------------------
.. image:: /workflow-guides/waf/f5-xc-waf-on-k8s/assets/WAAP-CE-k8s.jpeg


Manual step by step process for deployment:
--------------------------------------------
Please refer `manual-workflow.rst <./manual-workflow.rst>`__ for more details.


Step by step process using automation scripts:
-----------------------------------------------
Please refer `automation-workflow.rst <./automation-workflow.rst>`__ for more details.
