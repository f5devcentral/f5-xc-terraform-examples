F5 Distributed Cloud WAF deployment on k8s
===========================================

Objective :
-----------

Use this repo configuration files and work-flow guides for deploying WAF on Kubernetes. Please check `Deploy WAAP Overview
article <https://community.f5.com/t5/technical-articles/deploy-waap-anywhere-with-f5-distributed-cloud/ta-p/313079>`__
or `WAAP on k8s
article <https://community.f5.com/t5/technical-articles/deploying-f5-distributed-cloud-waap-on-kubernetes/ta-p/317324>`__
for more details.

Architectural diagram :
-----------------------
.. image:: /workflow-guides/waf/f5-xc-waf-on-k8s/assets/MicrosoftTeams-image.png


Manual step by step process for deployment:
-------------------------------------------

Prerequisites:
^^^^^^^^^^^^^^

1. AWS (Amazon Web Services) account with CLI credentials
2. eksctl, kubectl and awscli tools already configured in a linux
   instance
3. .yml files needed for deployment (these files are available in
   workflow-guides/waf/f5-xc-waf-on-k8s/assets folder)
4. Access to F5 XC account

Steps:
^^^^^^

1.  If k8s cluster (EKS) is not already available, then from Linux
    terminal, check below command to deploy EKS. If needed update it as
    per you requirements.
    ``eksctl create cluster --name ce-k8s-new --version 1.21 --region ap-southeast-1 --nodegroup-name standard-workers --node-type t3.xlarge --nodes 1 --managed --kubeconfig admin.conf``

2.  Once above command is successful, run below command to obtain
    kubeconfig. If you want to use existing EKS, then update name and
    region in below command.
    ``aws eks update-kubeconfig --name ce-k8s-new --region ap-southeast-1``

3.  Login to your F5 XC console and navigate to “Multi-Cloud Network
    Connect”, next to “Manage” tab “Site Management” menu and then to
    “Site Tokens” drop-down. Create a new site token and copy the UID.

4.  Login to your F5 XC console and navigate to Cloud and Edge sites.
    Create a new site token and copy the UID.

5.  Open the ce_k8s.yml file below and update Latitude, Longitude, token
    ID & other fields (from lines 143-158) as per your infrastructure.

6.  Execute below command in terminal to deploy CE site -
    ``kubectl apply -f ce_k8s.yml``

7.  In F5 XC console navigate to Site management –> then to
    Registrations tab and approve the pending record

8.  Wait for 10-15 mins and check all XC related pods are running in
    ves-system namespace. Also check if this new CE site comes up as
    online in F5 XC console sites list

9.  From terminal, run below command to deploy bookinfo demo app -
    ``kubectl apply -l version!=v2,version!=v3 -f https://raw.githubusercontent.com/istio/istio/release-1.16/samples/bookinfo/platform/kube/bookinfo.yaml``

10.  Download ce-k8s-lb.yml file from this repo and run this file to
    create k8s load balancer - ``kubectl apply -f ce-k8s-lb.yml``

11. Login to F5 XC console and navigate to load balancer section

12. Create an origin pool with below configuration

a. Select k8s service name and provide value as “productpage.default”
b. In Sites section, select newly created CE site from drop-down
c. In network option, select “Outside network”
d. Save above config and in port section provide 9080

13. Create a http LB with below details

a. Provide some name and domain name
b. In Origin pool section, select above origin pool
c. Advertise this as custom VIP and select our newly created CE site
d. Select network as “Inside and Outside Network”

14. Create a web application firewall (WAF) with mode as “Blocking” and
    with default settings.
15. Open Load balancer in edit mode and apply this WAF configuration.

Step by step process using automation scripts:
----------------------------------------------
Please refer `automation-workflow.rst <./automation-workflow.rst>`__ for more details.

Development
-----------

Outline any requirements to setup a development environment if someone
would like to contribute. You may also link to another file for this
information.

Support
-------

For support, please open a GitHub issue. Note, the code in this
repository is community supported and is not supported by F5 Networks.
