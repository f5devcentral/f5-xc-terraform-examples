
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

2.  Create an IAM OIDC identity provider ( for configuration steps click `here <https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html>`__ ) and an IAM role with permission policy: "AmazonEBSCSIDriverPolicy" ( for configuration steps click `here <https://docs.aws.amazon.com/eks/latest/userguide/csi-iam-role.html>`__ follow this document till step 10).

3.  Add "Amazon EBS CSI driver" add-on to the created EKS cluster and attach the IAM role created in STEP 2 to this add-on.

4.  Once above command is successful, run below command to obtain
    kubeconfig. If you want to use existing EKS, then update name and
    region in below command.
    ``aws eks update-kubeconfig --name ce-k8s-new --region ap-southeast-1``

5.  Login to your F5 XC console and navigate to “Multi-Cloud Network
    Connect”, next to “Manage” tab “Site Management” menu and then to
    “Site Tokens” drop-down. Create a new site token and copy the UID.

6.  Login to your F5 XC console and navigate to Cloud and Edge sites.
    Create a new site token and copy the UID.

7.  Open the ce_k8s.yml file below and update Latitude, Longitude, token
    ID & other fields (from lines 143-158) as per your infrastructure.

8.  Execute below command in terminal to deploy CE site -
    ``kubectl apply -f ce_k8s.yml``

9.  In F5 XC console navigate to Site management –> then to
    Registrations tab and approve the pending record

10.  Wait for 10-15 mins and check all XC related pods are running in ves-system namespace. Also check if this new CE site comes up as online in F5 XC console sites list

11.  From terminal, run below command to deploy bookinfo demo app -
    ``kubectl apply -l version!=v2,version!=v3 -f https://raw.githubusercontent.com/istio/istio/release-1.16/samples/bookinfo/platform/kube/bookinfo.yaml``

12. Download ce-k8s-lb.yml file from this repo and run this file to create k8s load balancer - ``kubectl apply -f ce-k8s-lb.yml``

13. Login to F5 XC console and navigate to load balancer section

14. Create an origin pool with below configuration

a. Select k8s service name and provide value as “productpage.default”
b. In Sites section, select newly created CE site from drop-down
c. In network option, select “Outside network”
d. Save above config and in port section provide 9080

15. Create a http LB with below details

a. Provide some name and domain name
b. In Origin pool section, select above origin pool
c. Advertise this as custom VIP and select our newly created CE site
d. Select network as “Inside and Outside Network”

16. Create a web application firewall (WAF) with mode as “Blocking” and
    with default settings.
17. Open Load balancer in edit mode and apply this WAF configuration.
18. If want to access this application open a linux shell or CMD, login to AWS console with your credentials, download the kubectl file for this load balancer and check services. 
19. Copy the load balancer DNS with name "lb-ver" and send request with XC LB FQDN as a Host header which should provide the application response as shown below

.. image:: /workflow-guides/waf/f5-xc-waf-on-k8s/assets/lb.jpg
.. image:: /workflow-guides/waf/f5-xc-waf-on-k8s/assets/postman.JPG

20. If needed, please delete all resources created manually from bottom to cleanup the infra for ex. XC resources first then EKS and finally AWS resources.


Development
-----------

Outline any requirements to setup a development environment if someone
would like to contribute. You may also link to another file for this
information.

Support
-------

For support, please open a GitHub issue. Note, the code in this
repository is community supported and is not supported by F5 Networks.
