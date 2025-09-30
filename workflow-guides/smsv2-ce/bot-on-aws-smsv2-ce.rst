F5 Distributed Cloud SMSv2 CE on AWS with Bot Defense
#########################################################
Introduction
--------------
This demo guide provides step-by-step walkthrough for enabling Bot Defense on Secure Mesh Site v2 (SMSv2) Customer Edge (CE) site manually using F5 Distributed Cloud (XC) console.

Contents
--------------
- Deploying SMSv2 CE in AWS
- Deploying Client VM and applications for testing
- Verifying Connectivity between CE site and Client VM through SLI
- Creating Origin Pool in Distributed Cloud
- Creating Load Balancer in Distributed Cloud
- Creating Bot Defense configuration and assigning it to LB
- Verifying Bot Defense with malicious requests

Prerequisites
--------------
- Access to AWS portal
- Access to F5 Distributed Cloud (XC) account

Steps to deploy Secure Mesh Site v2 in AWS
--------------
To deploy Secure Mesh Site v2 (SMSv2) in AWS, follow this `link <https://docs.cloud.f5.com/docs-v2/multi-cloud-network-connect/how-to/site-management/deploy-sms-aws-clickops>`__

.. image:: ./assets/aws/AWS-SITE.png

Steps to deploy VM (Client VM) running application workloads
--------------

1. Login to AWS portal

2. Search for EC2 and click on “Launch instance”

3. Provide instance “Name” and select the OS image (for this demonstration Ubuntu OS is considered)

.. image:: ./assets/aws/AWS-BOT-1.png

4. Select below details:
    - “Instance Type”
    - “Key pair” for accessing the instance
    - VPC created earlier for SMSv2 CE
    - Select SLI subnet to communicate between the CE and Client VM
    - Enable “Auto-assign public IP” to access the instance through SSH
    - Firewall (security groups) -> Click “Select existing security group” and select the security group created for Client VM which has minimal access based on rules created
    - Configure storage -> Select storage based on requirement
    - Click “Launch instance”

.. image:: ./assets/aws/AWS-BOT-2.png

.. image:: ./assets/aws/AWS-BOT-3.png

5. Wait for some time for the instance to launch and start running

6. Once the instance is up and running, check the private IP assigned and ping from SMSv2 CE site, as both SMSv2 CE and Client VM are connected to the same VPC and SLI subnet, ping should succeed, and 0% packet loss should be observed.

.. image:: ./assets/aws/AWS-BOT-4.png

7. Once the connection is established between CE site and VM, connect to the VM through SSH to deploy application. Execute below commands to deploy a vulnerable application (here “JuiceShop” is used)
    - $ sudo apt update
    - $ sudo apt install docker.io
    - $ sudo docker run -d -p 3000:80 vulnerables/web-dvwa

Accessing applications through Load Balancers
--------------
To access the applications installed in the Client machine through SMSv2 Customer Edge (CE), below configurations needs to be followed:

    1. Creating “Origin Pool”
    2. Creating “LB”
    3. Configuring “Bot Defense” and applying on the load balancer

Creating Origin Pool
============
1. Under “Multi-Cloud App Connect”, select Load Balancers-> Origin Pools. Click “Add Origin Pool”

.. image:: ./assets/aws/smsv2-aws-op1.png

2. Provide a name to the Origin Pool and click “Add Item” under Origin Servers

3. Select Origin Server Type IP address of Origin Server on given Sites and provide IP, select VMware site created from the dropdown and make sure Select Network on the site is set to “Inside Network” and click “Apply”

*Note: IP address and Site might vary based on your configuration*

.. image:: ./assets/aws/smsv2-aws-op2.png

4. Origin Server details will populate in the Origin Pool page, provide the port of the Ubuntu machine where the application is exposed (in this case 3000) and click “Add Origin Pool”

.. image:: ./assets/aws/smsv2-aws-op3.png

5. After creating the Origin Pool, this can be used in Load Balancer to access the application.

Creating Load Balancer
============
1. Under “Multi-Cloud App Connect”, select Load Balancers-> HTTP Load Balancers. Click “Add HTTP Load Balancer”

.. image:: ./assets/aws/smsv2-aws-lb1.png

2. Provide name for LB and domain with valid sub-domain

*Note: You should be having domain to use for LB and it should be able to resolve for the FQDN to be accessible*

.. image:: ./assets/aws/smsv2-aws-lb2.png

3. Click on “Add Item” under Origin Pool

.. image:: ./assets/aws/smsv2-aws-lb3.png

4. Select the origin pool created earlier and click “Apply”

.. image:: ./assets/aws/smsv2-aws-lb4.png

5. Under “Bot Protection” click “Enable Bot Defense Standard”, select your desired region and click “Configure” under “Bot Defense Policy”. A sub-page will open, click “Configure” under “Protected App Endpoints”. One more sub-page will open, click “Add Item”

.. image:: ./assets/aws/smsv2-aws-lb5.png

.. image:: ./assets/aws/smsv2-aws-lb6.png

.. image:: ./assets/aws/smsv2-aws-lb7.png

6. For this scenario, we’re considering the “login” endpoint with “POST” request should not be brute forced using bots, so bot protection is enabled for “login” endpoint to “Block” and configuration is created as per that requirement and applied

.. image:: ./assets/aws/smsv2-aws-lb8.png

.. image:: ./assets/aws/smsv2-aws-lb9.png

7. Verify the “Bot Defense Policy” is configured

.. image:: ./assets/aws/smsv2-aws-lb10.png

8. Click “Add HTTP Load Balancer” and wait for around ~5 minutes for LB to provision and come up completely.

.. image:: ./assets/aws/smsv2-aws-lb11.png

9. Access the LB URL and DVWA application should be available which is deployed in Client (Ubuntu) VM using docker and exposed through port 3000. Login by entering default credentials (admin/admin). Observe login is successful though browser

.. image:: ./assets/aws/smsv2-aws-lb12.png

.. image:: ./assets/aws/smsv2-aws-lb13.png

10. Send the same “POST” request to the LB using “Postman” or any other automated/command line tool, observe the request will be blocked

.. image:: ./assets/aws/smsv2-aws-lb14.png

11. Detailed log about the bot attempt can be viewed in F5 Distributed Cloud Console

.. image:: ./assets/aws/smsv2-aws-lb15.png

Conclusion
--------------
This guide demonstrated how to enable Bot Defense on an SMSv2 CE site using the F5 Distributed Cloud console. You deployed the CE in AWS, set up a test client, and configured origin pools and load balancers. Bot Defense was successfully applied and verified with test attacks. This setup also supports additional security services like API Security, WAF, and DDoS protection, allowing for flexible and robust application protection.








