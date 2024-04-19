Manual step by step process to connect and secure distributed Generative AI applications with F5 XC AppConnect and XC WAF
============================================================================================================================

Prerequisites
**************
- F5 Distributed Cloud Console SaaS account
- Access to Amazon Web Service (AWS) Management console & Command Line
- Access to Google Cloud (GCP) Management console & Command Line
- Install Kubectl command line tool to connect and push the app manifest file to EKS and GKE clusters


Create AWS credentials in XC by following the steps mentioned in this `Devcentral article <https://community.f5.com/kb/technicalarticles/creating-a-credential-in-f5-distributed-cloud-to-use-with-aws/298111>`_ 

Create GCP credentials in XC by following the steps mentioned in this `Devcentral article <https://community.f5.com/kb/technicalarticles/creating-a-credential-in-f5-distributed-cloud-for-gcp/298290>`_ 

Deployment Steps
*****************
To deploy an AppStack mk8s cluster on an AWS CE Site, steps are categorized as mentioned below.

1. In AWS console, create the EKS cluster
2. Using Kubectl, deploy the LLM workload on the EKS cluster
3. Deploy the Distributed Cloud VPC site Customer Edge workload on the EKS cluster
4. In GCP console, create the GKE cluster
5. Using Kubectl, deploy the GenAI front-end application on the GKE cluster
6. Deploy the Distributed Cloud GCP site Customer Edge workload on the GKE cluster
7. Publish the LLM service from EKS as a local service in GKE
8. Advertise externally GenAI application through a GCP NLB
9. Test the GenAI application for sensitive information disclosure
10. Enable DataGuard on the HTTP LoadBalancer
11. Retest the GenAI application for sensitive information disclosure



Below we shall take a look into detailed steps as mentioned above.

1.    In AWS console, create the EKS cluster following the steps mentioned in this `article <https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html>`_ and complete the steps to configure your computer to communicate with your cluster.

2.    Using Kubectl, deploy the LLM workload on the EKS cluster using the following configuration:
    
      .. code-block::
        
        apiVersion: v1
        kind: Namespace
        metadata:
          name: llm
        ---
        apiVersion: v1
        kind: Service
        metadata:
          name: llama
          labels:
            app: llama
          namespace: llm
        spec:
          type: ClusterIP
          ports:
          - port: 8000
          selector:
            app: llama
        
        ---
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          name: llama
          namespace: llm
        spec:
          selector:
            matchLabels:
              app: llama
          replicas: 1
          template:
            metadata:
              labels:
                app: llama
            spec:
              containers:
              - name: llama
                image: registry.gitlab.com/f5-public/llama-cpp-python:latest
                imagePullPolicy: Always
                ports:
                - containerPort: 8000
        
        ---
        apiVersion: appprotect.f5.com/v1beta1
        kind: APPolicy
        metadata:
          name: llama
          namespace: llm
        spec:
          policy:
            enforcementMode: blocking
            name: llama
            description: NGINX App Protect WAF API Security Policy for the OpenAI
            template:
              name: POLICY_TEMPLATE_NGINX_BASE
            open-api-files:
            - link: https://gitlab.com/f5-public/llama-cpp-python/-/raw/main/OpenAI-Swagger.yaml
            blocking-settings:
              violations:
              - block: true
                description: Disallowed file upload content detected in body
                name: VIOL_FILE_UPLOAD_IN_BODY
              - block: true
                description: Mandatory request body is missing
                name: VIOL_MANDATORY_REQUEST_BODY
              - block: true
                description: Illegal parameter location
                name: VIOL_PARAMETER_LOCATION
              - block: true
                description: Mandatory parameter is missing
                name: VIOL_MANDATORY_PARAMETER
              - block: true
                description: JSON data does not comply with JSON schema
                name: VIOL_JSON_SCHEMA
              - block: true
                description: Illegal parameter array value
                name: VIOL_PARAMETER_ARRAY_VALUE
              - block: true
                description: Illegal Base64 value
                name: VIOL_PARAMETER_VALUE_BASE64
              - block: true
                description: Disallowed file upload content detected
                name: VIOL_FILE_UPLOAD
              - block: true
                description: Illegal request content type
                name: VIOL_URL_CONTENT_TYPE
              - block: true
                description: Illegal static parameter value
                name: VIOL_PARAMETER_STATIC_VALUE
              - block: true
                description: Illegal parameter value length
                name: VIOL_PARAMETER_VALUE_LENGTH
              - block: true
                description: Illegal parameter data type
                name: VIOL_PARAMETER_DATA_TYPE
              - block: true
                description: Illegal parameter numeric value
                name: VIOL_PARAMETER_NUMERIC_VALUE
              - block: true
                description: Parameter value does not comply with regular expression
                name: VIOL_PARAMETER_VALUE_REGEXP
              - block: true
                description: Illegal URL
                name: VIOL_URL
              - block: true
                description: Illegal parameter
                name: VIOL_PARAMETER
              - block: true
                description: Illegal empty parameter value
                name: VIOL_PARAMETER_EMPTY_VALUE
              - block: true
                description: Illegal repeated parameter name
                name: VIOL_PARAMETER_REPEATED
        
        ---
        apiVersion: appprotect.f5.com/v1beta1
        kind: APLogConf
        metadata:
          name: logconf
          namespace: llm
        spec:
          filter:
            request_type: all
          content:
            format: default
            max_request_size: any
            max_message_size: 5k
        
        ---
        apiVersion: appprotectdos.f5.com/v1beta1
        kind: APDosPolicy
        metadata:
          name: dospolicy
          namespace: llm
        spec:
          mitigation_mode: "conservative"
          signatures: "on"
          bad_actors: "off"
          automation_tools_detection: "off"
          tls_fingerprint: "off"
        
        ---
        apiVersion: appprotectdos.f5.com/v1beta1
        kind: APDosLogConf
        metadata:
           name: doslogconf
           namespace: llm
        spec:
           filter:
              traffic-mitigation-stats: all
              bad-actors: top 10
              attack-signatures: top 10
        
        ---
        apiVersion: appprotectdos.f5.com/v1beta1
        kind: DosProtectedResource
        metadata:
          name: dos-protected
          namespace: llm
        spec:
          enable: true
          name: "llama"
          apDosPolicy: "llm/dospolicy"
          apDosMonitor:
            uri: "http://llama:8000/v1/completions"
            protocol: "http1"
            timeout: 5
          dosSecurityLog:
            enable: true
            apDosLogConf: "llm/doslogconf"
            dosLogDest: "10.0.134.70:5261"
        
        
        ---
        apiVersion: networking.k8s.io/v1
        kind: Ingress
        metadata:
          name: llama
          namespace: llm
          annotations:
            appprotect.f5.com/app-protect-policy: "llm/llama"
            appprotect.f5.com/app-protect-enable: "True"
            appprotect.f5.com/app-protect-security-log-enable: "True"
            appprotect.f5.com/app-protect-security-log: "llm/logconf"
            appprotect.f5.com/app-protect-security-log-destination: "syslog:server=10.0.134.70:5261"
            appprotectdos.f5.com/app-protect-dos-resource: "llm/dos-protected"
            nginx.org/proxy-read-timeout: "3600"
            nginx.org/proxy-send-timeout: "3600"
        spec:
          ingressClassName: nginx
          defaultBackend:
            service:
              name: llama
              port:
                number: 8000
          rules:
          - host: "*.com"
            http:
              paths:
              - path: "/"
                pathType: Prefix
                backend:
                  service:
                    name: llama
                    port:
                      number: 8000




2.   Creating AWS VPC Site object from F5 XC Console:
      **Step 1.1**: Login to F5 XC Console
            a. From the F5 XC Home page, ``Select the Multi-Cloud Network Connect`` Service
            b. Select Manage > Site Management > AWS VPC Sites in the configuration menu. Click on Add AWS VPC Site.
            c. Enter a name of your VPC site in the metadata section.
      **Step 1.2**: Configure site type selection
            a. Select a region in the AWS Region drop-down field. 
            b. Create New VPC by selecting New VPC Parameters from the VPC drop-down. Enter the CIDR in the ``Primay IPv4 CIDR blocks`` field. 
            c. Select Ingress Gateway (One Interface) for the ``Select Ingress Gateway or Ingress/Egress Gateway`` field.
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


.. figure:: assets/aws-vpc-site.png
Fig : AWS VPC Site


3.     Deploy the App to mk8s cluster
4.     Configuring Origin Pool and HTTPS LB in F5 XC Console
        **Step 4.1**: Creating Origin Pool
               In this process, we configure Origin pool with server as AWS VPC site and Advertise in HTTP Load Balancer.

               a. Log into F5 XC Console and Click on Multi-Cloud App Connect.
               b. Click Manage > Load Balancers > Origin Pools and Click ``Add Origin Pool``.
               c. In the name field, enter a name. Click on Add Item button in Origin Servers section.
               d. From the ``Select type of Origin Server`` menu, select ``IP address of Origin Server on given Sites`` to specify the node with its private IP address.
               e. Select ``Site`` from the ``Site or Virtual Site`` drop-down and select the AWS VPC site created in step 1.
               f. Select ``Outside Network`` for ``Select Network on the Site`` drop-down. Click on Apply.
               g. In ``Origin server Port`` enter the port number of the frontend service from step 3.1
               h. Click on Save and Exit.

               .. figure:: assets/origin-pool.png
               Fig : Origin Pool

        **Step 4.2**: Creating HTTPS Load Balancer with VIP advertisement
               a. Log into F5 XC Console and Click on Multi-Cloud App Connect.
               b. Click Manage > Load Balancers > HTTP Load Balancers and Click ``Add HTTP Load Balancer``.
               c. In the name field, enter the name of the LB, In the Domains field, enter a domain name.
               d. From the Load Balancer Type drop-down menu, Select HTTPS to create HTTPS load balancer.
               e. From the Origins sections, Click on Add Item to add the origin pool created in step 4.1 under ``Select Origin Pool Method`` drop-down menu. Click on Apply.
               f. Navigate to Other Setting section, From the VIP Advertisement  drop-down menu, Select Custom. Click  Configure in the Advertise Custom field to perform the configurations and click on Add Item.
               g. From ``Select Where to Advertise`` menu, select Site. From the ``Site Network`` menu, select Outside Network from the drop-down.
               h. From the Site Referrence menu, Select the AWS VPC site created in step 1. Click on Apply.
               i. Click on Apply and ``Save and Exit``.

.. figure:: assets/https-lb.png
Fig : HTTPS LB

Deployment Verification
************************
To verify the deployment we shall follow the below steps to make sure users can able to access the application deployed,

.. figure:: assets/langserve-api.png
Fig: LangServe API

1. Open the Postman
2. Enter the domain name of the HTTPS Load Balancer in the URL field.
3. Update the Host header as the domain name of the Load Balancer from the F5 XC Console.
4. Generate a POST request.


Conclusion
###########
The F5 XC's Customer Edge AppStack mk8s on AWS Public Cloud Platform provides support for Inference at the Edge and secures the Generative AI Applications deployed on this platform.

