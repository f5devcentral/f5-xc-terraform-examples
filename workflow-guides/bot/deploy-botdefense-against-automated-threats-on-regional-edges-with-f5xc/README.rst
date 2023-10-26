Deploy Bot Defense against Automated Threats on Regional Edges with F5 XC
===========================================

Objective :
-----------

Use this repo configuration files and work-flow guide for deploying WAAP
on Kubernetes. Please check `Deploy XC Bot Defense as Code (IaC) or SaaS Console Anywhere <https://community.f5.com/t5/technical-articles/deploy-xc-bot-defense-as-code-iac-or-saas-console-anywhere/ta-p/323272>`__
article for more details.

Architectural diagram :
-----------------------

Manual step by step process for deployment:
-------------------------------------------

Console Deployment Prerequisites:
^^^^^^^^^^^^^^

1. F5 Distributed Cloud Account (F5XC)
2. kubectl already configured in a linux
   instance
3. Access to F5 XC account

Steps:
^^^^^^

You can use the Kubernetes manifest called airflask.yaml located in the `airline-app directory <https://github.com/f5devcentral/f5-xc-waap-terraform-examples/tree/main/workflow-guides/bot/deploy-botdefense-against-automated-threats-on-regional-edges-with-f5xc/airline-app>`__ to bring up the pod in your vk8s environment
 
Setting up vk8s:
================

1. Navigate to *App > Applications > Virtual K8s*.
2. Create a site.

After the site is created:
---------------------------

3. Navigate to *Actions > Kubeconfig* to download the kubeconfig, which allows `kubectl` to control the vk8s cluster.
4. If you don't already have kubectl, download it from `Kubernetes Tools <https://kubernetes.io/docs/tasks/tools/>`_
5. Move the downloaded file into `~/.kube/config`.
6. Validate your ability to communicate with vk8s using the command "kubectl get pods". This should show no pods but should not produce an error.

Setting up the Airline app in vk8s:
====================================

7. Run the following command to apply the configuration from the previously downloaded `airflask.yaml <https://github.com/f5devcentral/f5-xc-waap-terraform-examples/tree/main/workflow-guides/bot/deploy-botdefense-against-automated-threats-on-regional-edges-with-f5xc/airline-app>`__ in your working directory: "kubectl apply -f airflask.yaml"
8. Run `kubectl get pods` to verify that an airline pod has been created. The output should resemble the following

![](assets/kubectlgetpds.png)





Step by step process using automation scripts:
----------------------------------------------

**Coming soon**

Development
-----------

Outline any requirements to setup a development environment if someone
would like to contribute. You may also link to another file for this
information.

Support
-------

For support, please open a GitHub issue. Note, the code in this
repository is community supported and is not supported by F5 Networks.

