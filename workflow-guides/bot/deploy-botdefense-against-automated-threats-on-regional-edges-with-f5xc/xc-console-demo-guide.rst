Deploy Bot Defense against Automated Threats on Regional Edges with F5 XC
=========================================================================

Objective :
-----------

Use this repo and work-flow guide for deploying XC Bot Defense via our WAAP Connector
on Kubernetes. This guide will outline the steps for implementing this infrastructure via Console Steps as well as Automated method using Terraform

Bot Defense on RE Architectural Diagram :
-----------------------------------------
.. image:: assets/diagramRE3.png
   :width: 100%

Manual step by step process for deployment:
-------------------------------------------

Console Deployment Prerequisites:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. F5 Distributed Cloud Account (F5XC)
2. kubectl already configured in a linux
   instance
3. Access to F5 XC account
4. You will need to download the Kubernetes manifest called airflask.yaml located in the `airline-app directory <https://github.com/f5devcentral/f5-xc-waap-terraform-examples/tree/main/workflow-guides/bot/deploy-botdefense-against-automated-threats-on-regional-edges-with-f5xc/airline-app>`__ to bring up the pod in your vk8s environment

Steps:
^^^^^^
 
Creating your Namespace:
========================

1. Logging into your tenant via https://console.ves.volterra.io ensure you have a unique namespace configured. If not, navigate to Administration --> My Namespaces --> Add New
2. Switch into your newly created namespace


.. image:: assets/addnamespace.png
   :width: 50%


Setting up VK8's
================

1. Navigate to *Distributed Apps > Applications > Virtual Sites
2. Create a site

.. image:: assets/createsite3.png
   :width: 100%

After the site is created:
---------------------------

1. Navigate to *Actions > Kubeconfig* to download the kubeconfig, which allows `kubectl` to control the vk8s cluster.
2. If you don't already have kubectl, download it from `Kubernetes Tools <https://kubernetes.io/docs/tasks/tools/>`_
3. Move the downloaded file into `~/.kube/config`.
4. Validate your ability to communicate with vk8s using the command "kubectl get pods". This should show no pods but should not produce an error.


.. image:: assets/downloadkubeconfig.png
   :width: 100%


Setting up the Airline app in vk8s:
====================================

1. Run the following command to apply the configuration from the previously downloaded `airflask.yaml <https://github.com/f5devcentral/f5-xc-waap-terraform-examples/tree/main/workflow-guides/bot/deploy-botdefense-against-automated-threats-on-regional-edges-with-f5xc/airline-app>`__ in your working directory: "kubectl apply -f airflask.yaml"
2. Run `kubectl get pods` to verify that an airline pod has been created. The output should resemble the following:

.. image:: assets/kubectlgetpods.png
   :width: 35%


Adding the Airline App as a selectable Origin Pool:
------------------------------------------------------

1. Navigate to *Web App & API Protection > Manage > Load Balancers
2. Click on Manage Load Balancers and select Origin Pool*.
3. Click on *Add Origin Pool*.
4. Name it "airline-origin."
5. Under *Origin Servers*, click on *Add*.
6. In the dropdown menu labeled "type of origin server," select the Kubernetes service name of the origin server on the specified sites.
7. Set the service name to "airline-flask.your-namespacename" (e.g., for my namespace "k-rob," it would be "airline-flask.k-rob"). You can find your namespace name in the top right of the XC GUI.
8. Select "Site" under "Site or Virtual Site."
9. Choose "sj10-sjc" as the site (limiting the pod to run only on the SJC edge).
10. Select "vk8s networks on site" as the site network.


.. image:: assets/addoriginpool2.png
   :width: 100%


Setting up an HTTP load balancer to front-end the airline app
-------------------------------------------------------------
1. Navigate to Web App & API Protection > Manage > Load Balancers > HTTP Load Balancers and click on "Add HTTP Load Balancer" in the top left corner
2. Give you LB a name of "airline-lb"
3. Add a description of "bot defense for airline app"
4. Under "Domains and LB Type" create a ficticious domain called airline-app.lb
5. Under "Load Balancer Type" select "HTTP LB" and leave the "automatically manage DNS requests" unchecked
6. Set the "HTTP Listen Port Choice" to HTTP Listen Port and Listen Port to 80

.. image:: assets/domainlb.png
   :width: 100%

7. Under "Orgins" add your recently created origin pool called "airline-origin"
8. Scroll to the bottom under "Other Settings" and configure as shown in screenshot below

.. image:: assets/lbothersettings.png
   :width: 100%

9. Save and Exit

Verifying Application Availability via DNS:
===========================================
1. Verify access to your newly deployed container application by navigating to Web App & API Protection > your-namespace > Manage > Load Balancers and click on Virtual Host Ready under DNS Info Column
2. Copy the CNAME with the "ves-" prefix and paste it into your web browser to verify the airline application loads appropriately. 



.. image:: assets/airlineapp2.png
   :width: 100%



Setting up an HTTP load balancer to enable XC Bot Defense:
-------------------------------------------------------------

1. Navigate to Web App & API Protection > Manage > Load Balancers > HTTP Load Balancers
2. Next to your newly created HTTP Load Balancer click on the elipses under "actions" and select "manage configuration"
3. In the upper right corner of the window click on "edit configuration"
4. In the left nagivation go to "Bot Protection"
5. Enable the Bot Defense Configuration under the drop down menu. (By default, the service is disabled)
6. Set the Bot Defense Region to "US"

.. image:: assets/bdenable.png
   :width: 100%

Setting up an HTTP load balancer to configure the XC Bot Defense endpoint policy:
----------------------------------------------------------------------------------
1. Under Bot Defense Policy select "Edit Configuration" 
2. Under Protected App Endpoints select "Configure" and then select "add item"
3. Give your policy a name of "protect-signin"
4. Define a description as "credential stuffing protection on signin"
5. Under HTTP Methods add "Put" and "Post"
6. Under Endpoint Label select "Specify Endpoint Label Category" and set the flow label category to "Authentication" and set the flow label to "login"
7. Make sure that the Protocol is set to "BOTH" for both HTTP and HTTPS
8. In the Domain Matcher field select "Any Domain".
9. Under Path we'll set the Path Match to "Prefix" and in the Prefix field we'll enter "/user/signin" without quotes
10. In the Traffic Channel section we'll set this to "Web Traffic" since there is no mobile application for this use case
11. Under Bot Traffic Mitigation Action we'll set this to "Flag" for now to provide insights in the dashboard. Also ensure the Include Mitigation headers is set to "No Headers"
12. Under Good Bot Detection settings set this to "Allow All Good Bots to Continue to Origin"
13. Click Apply, and Apply again to bring you back to the Javascript insertion section. Leave the Javascript download path as /common.js

.. image:: assets/bdpolicy2.png
   :width: 100%

Setting up an HTTP load balancer to configure the XC Bot Defense Javascript Insertion:
--------------------------------------------------------------------------------------
1. Set the Web Client Javascript Mode to "Async JS with no-Caching"
2. Set the Javascript Insertion to "Insert Javascript in All Pages"
3. Set the Javascript location to "After <head> tag"
4. Leave the Mobile SDK section at default of "Disable Mobile SDK"
5. Click Apply and then Save and Exit

.. image:: assets/bdjsinsertion.png
   :width: 100%

Simulating Bot Traffic with CURL:
---------------------------------------
1. Within this repo you can download the `curl-stuff.sh <https://github.com/f5-xc-waap-terraform-examples/tree/main/workflow-guides/bot/deploy-botdefense-against-automated-threats-on-regional-edges-with-f5xc/bot/deploy-botdefense-against-automated-threats-on-regional-edges-with-f5xc/validation-tools/curl-stuff%20copy.sh>`__ Bash script in the validation-tools directory to run it against your web application to generate some generic Bot Traffic
2. After you've downloaded the curl-stuff.sh script you can edit the file using a text editor and replace the domain name on line 3 with the DNS name of your application. For example, curl -s ves-io-your-domain.ac.vh.ves.io/user/signin -i -X POST -d "username=1&password=1" you would replace the "ves-io-your-domain.ac.vh.ves.io" hostname with the DNS name for your newly deployed application. Note** Make sure to keep the /user/signin path of the URI as this is the protected endpoint we configured in the Bot Defense Policy.
3. Run the CURL script using "sh curl-stuff.sh" once or twice to generate bot traffic. Or you can always just copy the CURL command out of the script and manually enter it into a command prompt a few times. 

.. image:: assets/curl-stuff.png
   :width: 75%

Viewing the Results in the Overview Security Dashboard:
-------------------------------------------------------
1. Navigate to Overview > Dashboards > Security Dashboard. This dashboard provides and consolidated view of all of your load balancers and their security events. If you refresh the page you will see the bot traffic detection results.
2. If you scroll down you can see the Top Attack Sources which will contain the source IP Address of your host running the CURL Script
3. If you look at the Top Attack Paths you can see the /user/signin Path and the Domain of your Application behind the load balancer as well as some other information
4. Let's dive in deeper by drilling down into your specific load balancer that we've deployed by scrolling to the bottom of this page and selecting the load balancers. This will take you into the WAAP Dashboard for that particular load balancer. 

.. image:: assets/overviewdashboard.png
   :width: 100%

Viewing the Results in your Load Balancer Security Dashboard:
--------------------------------------------------------------
1. From here you will see many of the same statistics related to Security Events. We can drill down further by selecting the Bot Defense Tab on the top right 
2. In this Bot Defense view you will see a breakdown of the different traffic types from Good Bots, to Malicious Bots, Human Traffic etc...

.. image:: assets/lbbddashboard.png
   :width: 100%


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

