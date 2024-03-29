Manual step by step process to deploy and secure Generative AI applications at the Edge with F5 XC AppStack mk8s and XC WAF
============================================================================================================================

Prerequisites
**************
- F5 Distributed Cloud Console SaaS account
- Access to Amazon Web Service (AWS) Management console & Command Line
- Install Kubectl command line tool to connect and push the app manifest file to mk8s cluster
- Install Postman for verifying the deployment

Create AWS credentials in XC by following the steps mentioned in this `Devcentral article <https://community.f5.com/kb/technicalarticles/creating-a-credential-in-f5-distributed-cloud-to-use-with-aws/298111>`_ 

Deployment Steps
*****************
To deploy an AppStack mk8s cluster on an AWS CE Site, steps are categorized as mentioned below.

1. Create mk8s cluster
2. Create AWS VPC Site and attach the mk8s cluster
3. Deploy the App to mk8s cluster
4. Configure Origin Pool and HTTP LB 

Below we shall take a look into detailed steps as mentioned above.

1.   Creating AWS VPC Site object from F5 XC Console:
      **Step 1.1**: Login to F5 XC Console
            a. From the F5 XC Home page, ``Select the Multi-Cloud Network Connect`` Service
            b. Select Manage > Site Management > AWS VPC Sites in the configuration menu. Click on Add AWS VPC Site.
            c. Enter a name of your VPC site in the metadata section.
             .. figure:: Assets/mcn-connect.jpg
             Fig : F5 XC Console Home page
      **Step 1.2**: Configure site type selection
            a. Select a region in the AWS Region drop-down field. 
            b. Create New VPC by selecting New VPC Parameters from the VPC drop-down. Enter the CIDR in the ``Primay IPv4 CIDR blocks`` field. 
            c. Select Ingress Gateway (One Interface) for the ``Select Ingress Gateway or Ingress/Egress Gateway`` field.
             .. figure:: Assets/waap-on-ce.jpg
             Fig 2: Configuring site type details
      **Step 1.3**: Configure ingress/egress gateway nodes
            a. Click on configure  to open the One-interface node configuration wizard.
            b. Click on Add Item button in the Ingress Gateway (One Interface) Nodes in AZ.
                 a. Select an option for the AWS AZ Name from the given suggestions that matches the configured AWS regsion.
                 b. Select New subnet from the Subnet for the local interface drop-down and enter the subnet address in the IPv4 Subnet text field.
      **Step 1.4**: Complete AWS VPC site object creation
            a. Select the AWS credentials object from the Cloud Credentials drop-down.
            b. Enter public key for remote SSH to the VPC site.
            c. Click on Save and Exit at the bottom right to complete creating the AWS VPC object.

      **Step 1.5**: Deploy AWS VPC site
            a. Click on the Apply button for the created AWS VPC site object.
            b. After a few minutes, the Site Admin State shows online and Status shows as Applied.


.. figure:: Assets/deploy-2.jpg
Fig : AWS VPC object online


2.     Creating an Amazon EKS Cluster along with Node Group:
        **Step 2.1**: Creating a subnet
               a. Open the Amazon VPC console at https://console.aws.amazon.com/vpc/ and click on Subnets in the navigation pane.
               b. Click on Create Subnet. 
               c. Select the VPC ID that created during deploying of AWS VPC site object mentioned in step 1. Name of the VPC is identified by "ves-vpc" followed by name of the CE site created from F5 XC console. (Ex. ves-vpc-waap-on-ce-aws)
               d. Provide the subnet name, Availability Zone and for IPv4 CIDR block enter the IPv4 CIDR subnet. This IPv4 CIDR should be within VPC network.
               e. Click on Create Subnet.
        **Step 2.2**: Enable auto-assign public IPv4 for subnets
               a. As a prerequisite, we need to enable the auto-assign public IPv4 for subnets associated to VPC.
               b.  Open the Amazon VPC console at https://console.aws.amazon.com/vpc/ and click on Subnets in the navigation pane.
               c. Identify and select the subnet that is associated to VPC (Ex. ves-vpc-waap-on-ce-aws) and click on Edit subnet setting from the Actions drop-down.
               d. From the Auto-assign IP setting section, enable auto-assign public IPv4 address check box. Click on Save.
               e. Repeat the above step for the subnet created in step 2.1 as well.
        **Step 2.3**: Creating using AWS Management Console
               a. Access Amazon EKS console at https://console.aws.amazon.com/eks/home#/clusters and navigate to the region in which AWS VPC site is created from F5 XC console.
               b. Click on Create from the Add Cluster drop-down.
               c. On the Configure Cluster page, provide the mandatory details such as Name, Kubernetes version and Cluster service role. Click on Next.
               d. From the Specify networking page, Select the VPC that is already created in AWS region. This is created while deploying the AWS VPC site object mentioned in step 1.
               e. Two subnets related to above VPC will be automatically selected. Selec the security group from the Security groups drop-down. Select ``Public`` Cluster end point access. Click on Next.
               f. Select the log types that you want to enable from the Configure logging page. Click on Next.
               g. From the Select add-ons page, choose the add-ons that you want to add to your cluster. Click on Next.
               h. From the Configure selected add-ons settings page, Select the version that you need to install and then click on Next.
               i. From the Review and Create page, review the details that we entered and click on Create. There by EKS Cluster will be created and wait for the cluster status to show as ACTIVE.
        **Step 2.4**: Creating a managed node group
               a. Navigate to the name of the EKS cluster that we want to create a managed node group.
               b. Select the Compute tab and click on Add node group.
               c. On the Configure node group page, fill the information as mentioned and click on Next.
               d. From the Set compute and scaling configure page, provide Node group compute & scaling configuration as per requirement, and then click on Next.
               e. On the Specify networking, Subnets will be auto selected as per the VPC. Click on Next.
               f. On the Review and Create page, review the managed node group configurations and click on create. Wait till the status of the node shows Ready.
3.     Deploying the App to EKS Node Group
        **Step 3.1**: Deploy online boutique demo application using the manifest file
               The kubectl command-line tool uses kubeconfig files to find the information it needed to choose a cluster and communicate with the API server of the cluster created in step 2.3. kubeconfig file for our Amazon EKS cluster is automatically created with the AWS CLI ``update-kubeconfig`` command. Applicaiton is deployed to the node once the communication is established to the cluster. https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html
               Below are the steps mentioned to deploy the online boutique application to Amazon EC2 nodes of the cluster,
               
               a. Creating and updating a kubeconfig file and along with example output
                aws eks update-kubeconfig --region region-code --name my-cluster
               An example output is displayed below,

                .. figure:: Assets/create-update-kubeconfig.jpg
               b. Execute ``kubectl apply -f <app_manifest.yaml>`` to deploy the application and ``kubectl get pods`` to verify the pod status.

                .. figure:: Assets/pod-status.jpg
               c. Execute kubectl commands to view and find the resources as below,
                .. figure:: Assets/svc-wide-2.jpg
4.     Configuring Origin Pool and HTTP LB in F5 XC Console
        **Step 4.1**: Creating Origin Pool
               In this process, we configure Origin pool with server as AWS VPC site and Advertise in HTTP Load Balancer.

               a. Log into F5 XC Console and Click on Multi-Cloud App Connect.
                .. figure:: Assets/app-connect.jpg
               b. Click Manage > Load Balancers > Origin Pools and Click ``Add Origin Pool``.
               c. In the name field, enter a name. Click on Add Item button in Origin Servers section.
               d. From the ``Select type of Origin Server`` menu, select ``IP address of Origin Server on given Sites`` to specify the node with its private IP address.
               e. Select ``Site`` from the ``Site or Virtual Site`` drop-down and select the AWS VPC site created in step 1.
               f. Select ``Outside Network`` for ``Select Network on the Site`` drop-down. Click on Apply.
                .. figure:: Assets/origin-server.jpg
               g. In ``Origin server Port`` enter the port number of the frontend service from step 3.1
                .. figure:: Assets/origin-server-port.jpg
               h. Click on Save and Exit.
        **Step 4.2**: Creating HTTP Load Balancer with VIP advertisement
               a. Log into F5 XC Console and Click on Multi-Cloud App Connect.
               b. Click Manage > Load Balancers > HTTP Load Balancers and Click ``Add HTTP Load Balancer``.
               c. In the name field, enter the name of the LB, In the Domains field, enter a domain name.
               d. From the Load Balancer Type drop-down menu, Select HTTP to create HTTP load balancer.
               e. From the Origins sections, Click on Add Item to add the origin pool created in step 4.1 under ``Select Origin Pool Method`` drop-down menu. Click on Apply.
               f. Navigate to Other Setting section, From the VIP Advertisement  drop-down menu, Select Custom. Click  Configure in the Advertise Custom field to perform the configurations and click on Add Item.
               g. From ``Select Where to Advertise`` menu, select Site. From the ``Site Network`` menu, select Outside Network from the drop-down.
               h. From the Site Referrence menu, Select the AWS VPC site created in step 1. Click on Apply.
               i. Click on Apply and ``Save and Exit``.
                .. figure:: Assets/lb.jpg

Deployment Verification
**********************
To verify the deployment we shall follow the below steps to make sure users can able to access the application deployed,

1. Open the postman
2. Enter the public IP of the AWS VPC site in the URL field.
3. Update the Host header as the domain name of the Load Balancer from the F5 XC Console.
4. Generate a GET request and monitor the request logs from F5 XC Console.
5. Create WAF Firewall and assign it to LB to verify blocking of WAF attacks.

.. figure:: Assets/testing.jpg
Fig: Accessing CE site deployed in AWS

.. figure:: Assets/req_logs.jpg
Fig: Accessing log requests from F5 XC Console

Applying the **WAF Firewall** to the Load Balancer and generating Cross Site Scripting attack to CE deployed on AWS to block the attack request

.. figure:: Assets/attack-block.jpg
Fig: Attack request getting rejected and generated support ID

.. figure:: Assets/waf-xc-logs.jpg
Fig: Observed WAF event logs from F5 XC Console

Conclusion
#########
With the deployment of F5 XC's Customer Edge on AWS Public Cloud Platform provides protection to the application from WAF attacks as well as Telemetry of request logs.

