# Secure Network Fabric (Multi-Cloud Networking)

# Table of Contents

- [Overview](#overview)
- [Setup Diagram](#setup-diagram)
- [1. Configure Environment](#1-configure-environment)
  - [1.1 Create AWS VPC using the AWS Management Console](#11-create-aws-vpc-using-the-aws-management-console)
  - [1.2 Create AWS EC2 instance in each VPC](#12-create-aws-ec2-instance-in-each-vpc)
  - [1.3 Create AWS Cloud Credentials](#13-create-aws-cloud-credentials)
  - [1.4 Create AWS TGW Site](#14-create-aws-tgw-site)
  - [1.5. Secure Mesh Site](#15-secure-mesh-site)
    - [1.5.1 Create Secure Mesh Site](#151-create-secure-mesh-site)
    - [1.5.2 Add Site Token](#152-add-site-token)
    - [1.5.3 Create VMware CE Site](#153-create-vmware-ce-site)
    - [1.5.4 Site Registration](#154-site-registration)
  - [1.6 Create VMware Ubuntu VMs](#16-create-vmware-ubuntu-vms)
  - [1.7 Install demo application](#17-install-demo-application)
  - [1.8 Create Site Mesh Group](#18-create-site-mesh-group)
- [2. Cloud Connect](#2-cloud-connect)
  - [2.1 Configure Cloud Connect](#21-configure-cloud-connect)
  - [2.2 Test connectivity between VPCs](#22-test-connectivity-between-vpcs)
- [3. Segment Connector](#3-segment-connector)
  - [3.1 Create Segment Connector](#31-create-segment-connector)
  - [3.2 Test connectivity between VPCs](#32-test-connectivity-between-vpcs)
- [4. Connect VMware Data Center](#4-connect-vmware-data-center)
  - [4.1 Configure VMware CE Site](#41-configure-vmware-ce-site)
  - [4.2 Test connectivity between AWS and VMware](#42-test-connectivity-between-aws-and-vmware)
- [5. ExtraNet: Network Centric Method](#5-extranet-network-centric-method)
  - [5.1 Configure AWS Assume Role](#51-configure-aws-assume-role)
  - [5.2 Configure Cloud Connect](#52-configure-cloud-connect)
  - [5.3 Configure Segment Connector](#53-configure-segment-connector)
  - [5.4 Test connectivity between External VPC and Prod VPC](#54-test-connectivity-between-external-vpc-and-prod-vpc)
- [6. Data Flow Analysis](#6-data-flow-analysis)
- [7. Firewall policies](#7-firewall-policies)
  - [7.1 Configure Firewall Policies](#71-configure-firewall-policies)
  - [7.2 Assign Policies to AWS TGW Site](#72-assign-policies-to-aws-tgw-site)
  - [7.3 Test connectivity between External VPC and Prod VPC](#73-test-connectivity-between-external-vpc-and-prod-vpc)
- [8. ExtraNet: App Centric Method](#8-extranet-app-centric-method)
  - [8.1 Remove External-Prod Segment Connector](#81-remove-external-prod-segment-connector)
  - [8.2 Create HTTP LB](#82-create-http-lb)
  - [8.3 Test connectivity](#83-test-connectivity)

# Overview

This guide provides the steps for a comprehensive Multi-Cloud Network Connect demo focused on:

- Configuration of AWS Environment including creating four AWS VPCs (dev, prod, shared and external) using the AWS Management Console, AWS EC2 instance in each VPC, two cloud credentials for ACME Corp and External Companies, AWS TGW Site to connect VPCs to, Secure Mesh Site and VMware Ubuntu VMs and, finally, Site Mesh Group;
- Creation of three Cloud Connects for prod, dev and shared VPCs using ACME Corp credentials created in the configuration part. Each Cloud Connect will have a VPC segment inside it to connect VPCs to our AWS TGW Site;
- Configuration of two Segment Connectors - prod to shared and dev to shared;
- Connection of VMware Data Center to ACME Corp by adding prod and dev interfaces;
- Creating of cloud connect for External Company and then adding a segment for it. Connection of external segment to prod one within segment connector;
- Configuration of Enhanced Firewall Policy with two rules and assigning it to the AWS TGW Site to allow http and https traffic and deny the rest.

# Setup Diagram

The objective of the demo is to demonstrate the connection of different VPCs from different accounts in one region. As a result of the demo, we will have AWS TGW Site with three VPCs (prod, dev and shared) connected to it. We will also have VMware CE Site with two VLANs (prod and dev) connected to the AWS TGW Site. We will connect an External Company to the prod VPC and VMware prod. Finally, we will configure Enhanced Firewall Policy and assign it to the site to control the traffic.

![alt text](./assets/setup-diagram.png)

# 1. Configure Environment

## 1.1 Create AWS VPC using the AWS Management Console

First, we will need to create four VPCs to connect to our AWS TGW Site: prod, dev, shared and external ones. We will use the AWS Management Console to do that since it lets us create a VPC plus the additional VPC resources that we need to run our application. Then we will create AWS EC2 instance in each created VPC.

In order to create dev, prod, shared and external VPCs we will use the following CIDR and Subnets:

| Name     | CIDR          | Subnets        |
| -------- | ------------- | -------------- |
| Prod     | 10.1.0.0/16   | 10.1.10.0/24   |
| Dev      | 10.2.0.0/16   | 10.2.10.0/24   |
| Shared   | 10.3.0.0/16   | 10.3.10.0/24   |
| External | 10.150.0.0/16 | 10.150.10.0/24 |

Log in to your AWS account and navigate to **Your VPCs** -> **Create VPC**. Click the **Create VPC** button. This will open the creation form. First, make sure to select **VPC and more** for the resources to create. Then give this VPC a name and type in the **10.1.0.0/16** CIDR.

![alt text](./assets/aws_cloud_vpc_constructor.png)

Select **1** Availability zone, **1** public and **0** private subnets, and fill in the public subnet **10.1.10.0/24**.

![alt text](./assets/aws_cloud_vpc_constructor1.png)

Make sure NAT Gateways and VPC endpoints are **None**. **Enable** both DNS options and click **Create VPC**.

![alt text](./assets/aws_cloud_vpc_constructor2.png)

Repeat the step above to create three more VPCs - Dev, Shared and External.

![alt text](./assets/aws_cloud_vpc_list.png)

## 1.2 Create AWS EC2 instance in each VPC

Now we will create AWS EC2 instances in each VPC created in the previous step. First, we will configure and create prod VM.

Start creating VM. In **Network Settings** select the created **VPC**, **subnet** and enable **Auto-assign public IP** in case you want to access the VM from the internet.

![alt text](./assets/aws_cloud_ec2_network.png)

Next, we will create a Firewall security group. Select **Create security group** and give it a name. We will also need to write description for the group.

![alt text](./assets/aws_cloud_ec2_network-3.png)

Scroll down and configure inbound security group rule to allow all traffic to come to this instance. Select **All traffic** from **Anywhere**. Optionally, you can specify the private IP address of the instance in the Network settings. Finally, click **Launch instance**. Repeat the same process for dev, shared and external VMs.

![alt text](./assets/aws_cloud_ec2_network-1.png)

You will see four created instances with their IDs, state, public and private addresses.

![alt text](./assets/aws_cloud_ec2_list.png)

Let's drill down into the prod VM to see more details. Click on it to expand the information on inbound and outbound rules. Make sure that the created security group allows all the traffic to the VM.

![alt text](./assets/aws_cloud_ec2_security.png)

Now that we have configured AWS environment, we can move on to creating AWS Cloud Credentials and AWS TGW Site to which we will later connect VPCs.

## 1.3 Create AWS Cloud Credentials

First, we need to create AWS Cloud Credentials. To do that, log into F5 Distributed Cloud Console and select **Multi-Cloud Network Connect** service. Navigate to **Site Management** and select **Cloud Credentials**. Click **Add Cloud Credentials**.

More detailed information on Cloud Credentials can be found [here](https://docs.cloud.f5.com/docs/how-to/site-management/cloud-credentials#aws-programmable-access-credentials).

![alt text](./assets/navigate-cloud-creds.png)

First, we will add credentials for the ACME Corp company. Give cloud credentials a name and fill in your **Access Key ID** for AWS authentication using access keys. Click the **Save and Exit** button.

![alt text](./assets/xc_cloud_credentials_acmecorp.png)

## 1.4 Create AWS TGW Site

Next, we will create the AWS TGW Site. In F5 Distributed Cloud Console navigate to **Site Management** and select **AWS TGW Sites**. Click the **Add AWS TGW Site** button.

![alt text](./assets/open-aws-tgw.png)

Give site a name. Then click **Add Label** and type in **company**. Assign it as a custom key. Next, type in **acmecorp** for key value.

![alt text](./assets/aws_tgw_name.png)

After that, we will configure AWS Credentials and Resources. Click **Configure** to proceed.

![alt text](./assets/aws_tgw_resources.png)

In AWS Resources, first open the **Credential Reference** drop-down menu and select the credential created earlier.

![alt text](./assets/aws_tgw_creds.png)

Second, configure region and services VPC: in the drop-down menu select **AWS Region**. Then select choosing VPC name and specify site name we just created. Finally, enter Primary IPv4 CIDR block - **10.100.0.0/16** for this flow.

![alt text](./assets/aws_tgw_vpc.png)

Scroll down to **Transit Gateway** and make sure to select **New Transit Gateway** and **Automatic** selection of BGP ASN config mode. F5XC will automatically assign a private ASN for TGW and F5XC Site.

![alt text](./assets/aws_tgw_tgw.png)

After Transit Gateway, move on to **Site Node Parameters**. Click the **Add Item** button to add a node.

![alt text](./assets/aws_tgw_site_node.png)

Select AWS availability zone. Then fill in **10.100.10.0/24** IPv4 Subnet for Workload Subnet and **10.100.20.0/24** for Outside Interface. For Subnet for Inside Interface select specifying new subnet and fill in **10.100.30.0/24** for IPv4 Subnet. Click **Apply**.

![alt text](./assets/aws_tgw_site_node_details.png)

Paste your Public SSH key for accessing nodes of the site.

![alt text](./assets/aws_tgw_ssh.png)

Make sure to select **No Worker Nodes** for deploy on the site and to disable VIP Advertisement to Internet on Site. Click **Apply**.

![alt text](./assets/aws_tgw_details_apply.png)

Take a look at the AWS TGW Site configuration and click **Save and Exit**. AWS TGW Site is created.

![alt text](./assets/aws_tgw_site_apply.png)

## 1.5. Secure Mesh Site

### 1.5.1 Create Secure Mesh Site

In this part, we are going to create a Secure Mesh Site to use it for registering and managing a site deployed on-premises on VMware. Go back to the F5 Distributed Cloud Console and select **Multi-Cloud Network Connect** service. Navigate to **Site Management** and select **Secure Mesh Sites**. Click **Add Secure Mesh Site**.

![alt text](./assets/navigate_sm_site_name.png)

First, give it a name. Then click **Add Label** and type in **company**. Assign it as a custom key. Finally, type in **acmecorp** for key value.

![alt text](./assets/xc_sm_site_name.png)

Next, move on to **Basic Configuration**. Open the **Generic Server Certified Hardware** drop-down menu and select **vmware-regular-nic-voltmesh**. Then type in **master-0** master node name. Lastly, fill in your public IP address. In this demo, we use **203.0.113.15** as a Public IP.

![alt text](./assets/xc_sm_site_basic_config.png)

Scroll down to **Network Configuration** and select **Custom Network Configuration** in its drop-down menu. Proceed to **View Configuration**.

![alt text](./assets/xc_sm_site_net_config.png)

Scroll down to the **Interface Configuration** section. Select **List of Interface** to add all interfaces belonging to the site. Click **Configure**.

![alt text](./assets/xc_sm_site_net_interface_list.png)

Click **Add Item** to start adding the first interface.

![alt text](./assets/xc_sm_site_net_interface_list_add.png)

Fill in interface description **eth0** and move on to configuring **Ethernet Interface**.

![alt text](./assets/xc_sm_site_net_interface_list_add_eth0.png)

Click in the **Ethernet Device** field and see suggestions. Select the one we added. Take a look at the configuration and click **Apply**.

![alt text](./assets/xc_sm_site_net_interface_list_add_eth0_details.png)

Proceed by clicking the **Apply** button.

![alt text](./assets/xc_sm_site_net_interface_list_add_eth0_apply.png)

Review the configured List of Interface and click **Apply**.

![alt text](./assets/xc_sm_site_net_interface_list_eth0_apply.png)

In the **Global Connections** section open the **Site Mesh Group Connection Type** drop-down menu and select **Site Mesh Group Connection Via Public Ip** which will use statically configured Public IPs. After that, click **Apply** to apply the configured Network Configuration.

![alt text](./assets/xc_sm_site_net_apply.png)

Finally, enable **Offline Survivability Mode** and click **Save and Exit**.

![alt text](./assets/xc_sm_site_apply.png)

### 1.5.2 Add Site Token

In the **Multi-Cloud Network Connect** service navigate to **Site Management** and select **Site Tokens**. Start adding a token by clicking the **Add Site Token** button.

![alt text](./assets/site-tokens-add.png)

Give token a name and click **Save and Exit**.

![alt text](./assets/xc_sm_site_token.png)

Expand the created token to see and copy its UID.

![alt text](./assets/xc_sm_site_token_details.png)

### 1.5.3 Create VMware CE Site

For the demo we need to create a VMware CE Site with two network interfaces - one for the **External network** and another for the **Internal network**.

External network will be used to connect to the internet and should have DHCP enabled with internet access. Internal network will be used to connect to the VMs in different VLANs.

For the internal network, we create a Virtual Switch with port **Internal Network** and assign VLAN ID **4095**. Setting 4095 as a VLAN ID will allow the VM to communicate with all VLANs.

![alt text](./assets/vmware_switch.png)

Next, we will create VMware CE Site.

If you use VMware vShpere Client, navigate to **Hosts and Clusters**. Right-click on the **Cluster** and select **Deploy OVF Template**.

If you use VMware ESXI, navigate to **Virtual Machines** and select **Create/Register VM**, then select **Deploy a virtual machine from an OVF or OVA file**.

![alt text](./assets/vmware_site_ova.png)

Open [F5 Distributed Cloud Console Documentation](https://docs.cloud.f5.com/docs/images/node-vmware-images) and download the **OVA Image** file. Use the downloaded file to deploy the VM. Set **vmware-ce-site** as the name of the VM.

![alt text](./assets/vmware_site_ova_image.png)

Select the storage type and datastore.

![alt text](./assets/vmware_site_storage.png)

Select the network for the VM. Make sure to select the **External Network** for the **outside** network adapter.

![alt text](./assets/vmware_site_opt.png)

Complete additional settings section where:

- hostname: master-0
- token: your Site Token UID from the [previous step](#152-add-site-token)
- password: your password to access the CE Site
- cluster name: your [Secure Mesh Site name](#151-create-secure-mesh-site)
- certified hardware: vmware-regular-nic-voltmesh
- longitude and latitude: your CE Site location

Click **Next** to proceed, review the settings and click **Finish** to deploy the VM.

![alt text](./assets/vmware_site_settings.png)

Once the VM is deployed, power it on and open the console. You will see the VM booting up. Attach the **Internal Network** to the VM.

![alt text](./assets/vmware_site_ext_net.png)

### 1.5.4 Site Registration

Go back to F5 Distributed Cloud Console and select **Multi-Cloud Network Connect** service. Navigate to **Site Management** and proceed to **Registrations**. You will see the site with pending registration. Accept the registration.

![alt text](./assets/xc_sm_site_approve.png)

This will open registration form. Take a look and click **Save and Exit**.

![alt text](./assets/xc_sm_site_approve_apply.png)

## 1.6 Create VMware Ubuntu VMs

Next, we will create Ubuntu VMs in each VLAN - prod and dev. Use any available Ubuntu image to create VMs.
Attach the VMs to the Internal Network and configure the network settings.

To simplify the process, we will use the same network for both VMs, but we configure them to be in different VLANs.

Below you can see an example of how to create Ubuntu VMs in each VLAN using netplan. In this example, we have two VMs - one in prod VLAN 100 and another in dev VLAN 200. Both VMs are in the same network, but they are configured to be in different VLANs and use XC Site as a default gateway.

**Production VM**:

```bash
cat /etc/netplan/50-cloud-init.yaml

network:
  version: 2
  ethernets:
    ens160:
      dhcp4: false
  vlans:
    ens160.100:
      id: 100
      link: ens160
      addresses:
        - 10.200.100.100/24
      routes:
        - to: 0.0.0.0/0
          via: 10.200.100.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
```

**Dev VM**:

```bash
cat /etc/netplan/50-cloud-init.yaml

network:
  version: 2
  ethernets:
    ens160:
      dhcp4: false
  vlans:
    ens160.200:
      id: 200
      link: ens160
      addresses:
        - 10.200.200.100/24
      routes:
        - to: 0.0.0.0/0
          via: 10.200.200.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
```

Reboot the VMs to apply the changes. Check the network configuration to make sure that the VLANs are configured correctly. Ping the default gateway to check the connectivity.

## 1.7 Install demo application

Sign in to each VM and install the demo nginx application. We will use it to test the connectivity between the VMs.

```bash
sudo apt update
sudo apt install -y nginx
```

## 1.8 Create Site Mesh Group

In this step we will, first, create a virtual site and then use it to create a site mesh group. Back in the F5 Distributed Cloud Console navigate to the **Shared Configuration** service. From there, select **Virtual Sites** and click the **Add Virtual Site** button.

![alt text](./assets/smg_add.png)

Give it a name, click **Add Label** and type in **company**. Assign it as a custom key. Finally, type in **acmecorp** for key value. Click **Save and Exit**.

![alt text](./assets/smg_details.png)

Select another service - **Multi-Cloud Network Connect** and proceed to **Networking**. Select **Site Mesh Groups** and click the **Add Site Mesh Group** button.

![alt text](./assets/smg_create.png)

Give it a name and select the virtual site we created earlier. Save the created group.

![alt text](./assets/smg_create_details.png)

# 2. Cloud Connect

In this part of the demo we will create three Cloud Connects - for prod, dev and shared, and add a segment to each. Later we will use the segments to establish connection using Segment Connector.

![alt text](./assets/cloud-connect-overview.gif)

## 2.1 Configure Cloud Connect

After creating AWS TGW Site with three VPCs, we can start creating three cloud connects for prod, dev and shared VPCs. Cloud Connects will let us connect VPCs to our AWS TGW Site.

In the F5 Distributed Cloud Console navigate to **Multi-Cloud Network Connect**. From there, select **Connectors** and choose **Cloud Connects**. Click on **Add Cloud Connect** to open the creation form.

![alt text](./assets/xc_connector_add.png)

The first cloud connect will be for the prod VPC. Give it a name.

![alt text](./assets/xc_connector_name.png)

Make sure to select **AWS TGW Site** as provider and then the name of the AWS TGW Site we created earlier. Then select the credentials we added a few steps earlier for the ACME Corp. Proceed to add VPC by clicking the **Add Item** button.

![alt text](./assets/xc_connector_provider_acme.png)

Add the prod VPC ID [created](#11-create-aws-vpc-with-constructor) earlier, make sure to select overriding default routes and click **Apply**. This will connect prod VPC to the AWS TGW Site.

![alt text](./assets/xc_connector_provider_vpc.png)

The added VPC will appear on the list. And finally, add a segment. Click **Add Item** in the segment drop-down menu.

![alt text](./assets/xc_connector_provider_vpc_result.png)

Give segment a name and make sure to allow its traffic to internet. Click **Continue**, and then **Save and Exit**. Prod connect will appear on the list.

![alt text](./assets/xc_connector_prod_segment.png)

Now we can add two more connects for the Dev and Shared VPCs. Follow the steps above and make sure to use correct VPC IDs. As a result, you will have three cloud connect objects added - one for Prod, one for Dev, and one more for Shared VPC.

![alt text](./assets/xc_connector_result.png)

## 2.2 Test connectivity between VPCs

Let's test the connectivity between the VPCs. Sign in to the Prod VM and run the following pings to the Dev and Shared VMs.

```bash
ubuntu@aws-prod-vm:~$ ping 10.2.10.100
PING 10.2.10.100 (10.2.10.100) 56(84) bytes of data.
--- 10.2.10.100 ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 4003ms
```

```bash
ubuntu@aws-prod-vm:~$ ping 10.3.10.100
PING 10.3.10.100 (10.3.10.100) 56(84) bytes of data.
--- 10.3.10.100 ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 4020ms
```

As we can see from the output, there is no connection between the Prod VM and Dev and Shared VMs since by default no inter-segment communication is allowed. This means that the VPCs are isolated from each other.

# 3. Segment Connector

In this part of the demo we will add two Segment Connectors. One will connect AWS Prod VM with AWS Shared VM, another - AWS Dev VM with AWS Shared VM.

![alt text](./assets/segment-connector-overview.gif)

## 3.1 Create Segment Connector

In this step we will add two segment connectors - prod-to-shared and dev-to-shared. Go back to F5 Distributed Cloud Console and select **Multi-Cloud Network Connect** service. Navigate to **Networking** and proceed to **Segment Connector**. Click the **Manage Segment Connections** button.

![alt text](./assets/xc_segment_connector.png)

In the **Segment Connectors** section, click **Add Item**.

![alt text](./assets/xc_segment_connector_add.png)

First, we will add segment connector for prod to shared. For the Source Segment, select the **prod segment** we created earlier. For the Destination Segment, select the **shared segment**. Make sure to select **Direct** connector type. Since segment connectors are bi-directional, we do not need to configure it in reverse direction - from shared to prod for Direct Connectors. Then click **Apply**. 

![alt text](./assets/xc_segment_connector_add_prod.png)

Repeat the step above to create one more segment connector for the dev segment. Select the **dev segment** as the source and the **shared segment** as the destination. Click **Apply**.

![alt text](./assets/xc_segment_connector_add_dev.png)

Take a look at the configuration and click **Save and Exit**.

![alt text](./assets/xc_segment_connector_apply.png)

## 3.2 Test connectivity between VPCs

Now let's test the established connection. Open CLI and run the following ping from AWS Prod VM to AWS Shared VM:

```bash
ubuntu@aws-prod-vm:~$ ping 10.3.10.100
PING 10.3.10.100 (10.3.10.100) 56(84) bytes of data.
64 bytes from 10.3.10.100: icmp_seq=1 ttl=61 time=170 ms
64 bytes from 10.3.10.100: icmp_seq=2 ttl=61 time=175 ms
64 bytes from 10.3.10.100: icmp_seq=3 ttl=61 time=172 ms
64 bytes from 10.3.10.100: icmp_seq=4 ttl=61 time=174 ms
--- 10.3.10.100 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 2002ms
```

As we can see from the output, the connection is successful.

Next, run the ping from AWS Prod VM to AWS Dev VM. 

```bash
ubuntu@aws-prod-vm:~$ ping 10.2.10.100
PING 10.2.10.100 (10.2.10.100) 56(84) bytes of data.
--- 10.2.10.100 ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 4003ms
```

As expected, there is no connection between AWS Prod VM and AWS Dev VM because we have not created a segment connector between them. Try the same ping from AWS Dev VM to AWS Prod VM and AWS Shared VM to check the connectivity.

# 4. Connect VMware Data Center

In this part of the demo we will configure VMware CE Site by adding two interfaces - prod and dev VLANs. As a result, we will have AWS Prod VM connected to VMware Prod VM, and the same for Dev VMs.

![alt text](./assets/wmware-overview.gif)

## 4.1 Configure VMware CE Site

In this part we will connect VMware to the site and configure its interfaces. Back in the F5 Distributed Cloud Console go to the **Multi-Cloud Network Connect** service and proceed to **Site Management**. Then select **Secure Mesh Sites**. Open the service menu of the [site](#151-create-secure-mesh-site) we created earlier and select **Manage Configuration**.

![alt text](./assets/xc_sm_site_list.png)

Click **Edit Configuration**.

![alt text](./assets/xc_sm_site_edit.png)

Scroll down to the **Network Configuration** and click **Edit Configuration**.

![alt text](./assets/xc_sm_site_edit_config.png)

After that, we will need to add two interfaces.

In the table below, you can see the interfaces we are going to add.

| Name | VLAN ID | Interface | IP Address      |
| ---- | ------- | --------- | --------------- |
| Prod | 100     | eth1.100  | 10.200.100.1/24 |
| Dev  | 200     | eth1.200  | 10.200.200.1/24 |

You will see the first interface configured earlier. Click **Add Item** to start adding the second **prod** interface.

![alt text](./assets/xc_sm_site_net_interface_list_add_1.png)

Fill in interface description and click **Configure** Ethernet Interface.

![alt text](./assets/xc_sm_site_net_interface_list_add_vlan100.png)

In the suggestions for Ethernet Device, select the added name. Then select **Specific Node** to apply configuration only to a device on node **master-0** added earlier. Lastly, select **VLAN Id** to configure a VLAN tagged ethernet interface and type in **100**.

![alt text](./assets/xc_sm_site_net_interface_list_add_vlan100_conf.png)

Scroll down to the **IP Configuration** section and select **Static IP** configuration of interface IP. Type in **10.200.100.1/24** IP address of the interface and prefix length.

![alt text](./assets/xc_sm_site_net_interface_list_add_vlan100_ip.png)

Next, in the **Virtual Network** section, choose the **Segment** option. From the drop-down menu, select **system/prod-segment**. Click **Apply** to proceed.

![alt text](./assets/segment-vn-prod.png)

Take a look at the second interface configuration and click **Apply**.

![alt text](./assets/xc_sm_site_net_interface_list_add_vlan100_apply_2.png)

You will see a list of two interfaces. Click **Add Item** to add the third one - for dev.

![alt text](./assets/xc_sm_site_net_interface_list_add_2.png)

Give the third interface a name and move on to configuring **Ethernet Interface**.

![alt text](./assets/xc_sm_site_net_interface_list_vlan200.png)

In the suggestions for Ethernet Device, select the added name. Then select **Specific Node** to apply configuration only to a device on node **master-0** added earlier. Lastly, select **VLAN Id** to configure a VLAN tagged ethernet interface and type in **200**.

![alt text](./assets/xc_sm_site_net_interface_list_vlan200_basic.png)

Scroll down to the **IP Configuration** section and select **Static IP** configuration of interface IP. Type in **10.200.200.1/24** IP address of the interface and prefix length.

![alt text](./assets/xc_sm_site_net_interface_list_vlan200_ip.png)

Next, in the **Virtual Network** section, choose the **Segment** option. From the drop-down menu, select **system/dev-segment**. Click **Apply** to proceed.

![alt text](./assets/segment-vn-dev.png)

Take a look at the second interface configuration and click **Apply**.

![alt text](./assets/xc_sm_site_net_interface_list_vlan200_apply_2.png)

Make sure to select **Site Mesh Group Connection Via Public Ip** and move on by clicking **Apply**.

![alt text](./assets/xc_sm_site_net_apply.png)

Click **Save and Exit** to apply the changes.

![alt text](./assets/xc_sm_site_update.png)

## 4.2 Test connectivity between AWS and VMware

Now that we have configured VMware CE Site, we can test the connectivity between AWS and VMware.

Sign in to the AWS Prod VM and run the following pings:

```bash
ubuntu@aws-prod-vm:~$ ping 10.200.100.100
PING 10.200.100.100 (10.200.100.100) 56(84) bytes of data.
64 bytes from 10.200.100.100: icmp_seq=1 ttl=61 time=232 ms
64 bytes from 10.200.100.100: icmp_seq=2 ttl=61 time=275 ms
64 bytes from 10.200.100.100: icmp_seq=3 ttl=61 time=244 ms
64 bytes from 10.200.100.100: icmp_seq=4 ttl=61 time=250 ms
--- 10.200.100.100 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 4002ms
```

```bash
ubuntu@aws-prod-vm:~$ ping 10.200.200.100
PING 10.200.200.100 (10.200.200.100) 56(84) bytes of data.
--- 10.200.200.100 ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 4010ms
```

As we can see from the output, the connection is successful between AWS Prod VM and VMware Prod VM. However, there is no connection between AWS Prod VM and VMware Dev VM because two segments Prod and Dev are not connected. This means that the VLANs are isolated from each other.

Sign in to the VMware Prod VM and run the following pings:

```bash
ubuntu@vmware-prod-vm:~$ ping 10.3.10.100
PING 10.3.10.100 (10.200.100.100) 56(84) bytes of data.
64 bytes from 10.3.10.100: icmp_seq=1 ttl=61 time=225 ms
64 bytes from 10.3.10.100: icmp_seq=2 ttl=61 time=287 ms
64 bytes from 10.3.10.100: icmp_seq=3 ttl=61 time=266 ms
64 bytes from 10.3.10.100: icmp_seq=4 ttl=61 time=252 ms
--- 10.200.100.100 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 4080ms
```

```bash
ubuntu@vmware-prod-vm:~$ ping 10.2.10.100
PING 10.2.10.100 (10.3.10.100) 56(84) bytes of data.
--- 10.2.10.100 ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 4087ms
```

From the output, we can see that the connection is successful between VMware Prod VM and AWS Shared VM.
But connection between VMware Prod VM and AWS Dev VM is not established.

# 5. ExtraNet: Network Centric Method

There are two ways to connect External Company and solve the ExtraNet problem:

a) Network Centric (outlined in this section) 

b) App Centric (outlined in section [ExtraNet: App Centric Method](#8-extranet-app-centric-method) below).

In this part we will connect External Company by adding a Cloud Connect/Segment for it. For this demo, we will assume that our company is offering a service running on the workload in VPC Prod 10.1.10.100 using HTTP/HTTPs to a 3rd party. According to this, workloads in the external VPC need to access an application in the production segment. Thus, we will need a segment connector between External and Prod segments. As a result we will establish connection between External Company VPC and AWS Prod VPC, as well as VMware Prod VM.

![alt text](./assets/external-overview.gif)

## 5.1 Configure AWS Assume Role

External Org/Company will not share AWS credentials with ACMECorp, however we still need F5 Distributed Cloud to connect & orchestrate the connectivity of the VPC to AWS TGW. In order to solve this, we will create a role within the external account that trusts F5 Distributed Cloud AWS Account & that has the necessary privileges as per our documentation.

So, in this part we will create an AWS Assume Role to allow F5 Distributed Cloud to assume the role and access the external company's AWS account. In this case, we don't have direct access to the external company's AWS account, so we need to create an Assume Role to allow F5 Distributed Cloud to access it without providing the credentials.

To create an Assume Role, you will need [F5 Distributed Cloud AWS Account Number which you can get by submitting a ticket](https://docs.cloud.f5.com/docs/reference/cloud-cred-ref/aws-tgw-pol-ref#f5-distributed-cloud-assume-role) in the XC portal.
From the main menu, navigate to **Administration** and select **Requests**. Click the **Add Request** button and fill in the form.

![alt text](./assets/sts_support_request.png)

Open AWS Management Console and navigate to **IAM**. From there, select **Policies** and click **Create policy**. For the policy, select **JSON** and paste the [following policy](https://docs.cloud.f5.com/docs/reference/cloud-cred-ref/aws-tgw-pol-ref#aws-tgw-policies). If you are using different AWS account, make sure to add "ram:*" to the list of actions. Remote Access Manager (RAM) is a service that enables you to share your resources with other AWS accounts. Click **Next** and give the policy a name. Click **Create policy**. If your policy is too long, you can split it into two or more policies.

![alt text](./assets/sts_create_policy.png)

In the **IAM** service, select **Roles** and click **Create role**. Select **Custom trust policy**. For the trust relationship policy, paste the policy below. Make sure to replace `<account-number>` with F5 Distributed Cloud AWS account number and `<tenant_id>` with the values you received from F5 Distributed Cloud.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::<account-number>:root"
            },
            "Action": "sts:AssumeRole",
            "Condition": {
                "StringEquals": {
                    "sts:ExternalId": [
                        "<tenant_id>"
                    ]
                }
            }
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::<account-number>:root"
            },
            "Action": "sts:TagSession"
        }
    ]
}
```

![alt text](./assets/sts_create_role.png)

Click **Next** and search for the policy you created earlier. Check the box next to it and click **Next**.

![alt text](./assets/sts_role_policy.png)

Give the role a name.

![alt text](./assets/sts_role_name.png)

Click **Create role** to finish creating the role.

![alt text](./assets/sts_role_save.png)

Open the role you created and copy the **Role ARN**.

![alt text](./assets/sts_get_arn.png)

Go back to the F5 Distributed Cloud Console and create Cloud Credentials for the External Company. Navigate to **Multi-Cloud Network Connect**, then click **Site Management** and select **Cloud Credentials**. Click **Add Cloud Credentials**.
In the **Cloud Credentials Type** drop-down menu, select **AWS Assume Role**. Then, paste the **Role ARN** you copied earlier. Add **Role Session Name** and click **Save and Exit**.

![alt text](./assets/sts_cloud_creds.png)

## 5.2 Configure Cloud Connect

In this part we will connect External Company by creating a cloud connect for it and adding a segment. After that, we will configure segment connector from external to prod segment. And lastly, we will test the configured connectivity.

Back in the F5 Distributed Cloud Console navigate to **Multi-Cloud Network Connect**. From there, select **Connectors** and choose **Cloud Connects**. Click on **Add Cloud Connect** to open the creation form.

![alt text](./assets/xc_connector_add_external.png)

Name the cloud connect object as **external-connector**.

![alt text](./assets/xc_connector_name_external.png)

Select **AWS TGW Site** as the provider and choose the [AWS TGW Site](#14-create-aws-tgw-site) we created earlier. Then, select the [credentials](#13-create-aws-cloud-credentials) for the external company. Proceed to add a VPC by clicking the **Add Item** button.

![alt text](./assets/xc_connector_provider_external.png)

Add the [external VPC ID](#11-create-aws-vpc-with-constructor) created earlier, make sure to select overriding default routes and click **Apply**.

![alt text](./assets/xc_connector_vpc_external.png)

The added VPC will appear on the list. And finally, add a segment. Open the segment drop-down menu and click **Add Item**.

![alt text](./assets/xc_connector_segment_external_add.png)

Give segment a name and make sure to allow its traffic to internet. Click **Continue**.

![alt text](./assets/xc_connector_segment_external_details.png)

Take a look at the configuration of cloud connect for the External Company. Complete creating by clicking **Save and Exit**.

![alt text](./assets/xc_connector_external_save.png)

Newly created Cloud Connect for the External Company will appear on the list. Make sure to use its special credentials we created [earlier](#13-create-aws-cloud-credentials).

![alt text](./assets/xc_connector_external_result.png)

## 5.3 Configure Segment Connector

Next step is to add a segment connector from External Company to the Prod VPC. Navigate to **Networking** and proceed to **Segment Connector**. Click the **Manage Segment Connections** button.

![alt text](./assets/xc_segment_connector_external.png)

In the **Segment Connectors** section, you will see two the connectors we added before. Click **Add Item**.

![alt text](./assets/xc_segment_connector_add_external.png)

Select **external-segment** for the source one, and **prod-segment** for the destination. Make sure to use **Direct** Connector Type and click **Apply**.

![alt text](./assets/xc_segment_connector_add_external_details.png)

The new segment connector will appear among others. Complete by clicking **Save and Exit**.

![alt text](./assets/xc_segment_connector_external_save.png)

Now we have three segment connectors added: prod-to-shared, dev-to-shared and external-to-prod.

![alt text](./assets/xc_segment_connector_external_result.png)

## 5.4 Test connectivity between External VPC and Prod VPC

Now that we have configured the segment connector between External and Prod segments, we can test the connection by running the below commands. Sign in to the AWS External VM and run the following pings:

```bash
ubuntu@aws-external-vm:~$ ping 10.1.10.100
PING 10.1.10.100 (10.1.10.100) 56(84) bytes of data.
64 bytes from 10.1.10.100: icmp_seq=1 ttl=61 time=315 ms
64 bytes from 10.1.10.100: icmp_seq=2 ttl=61 time=325 ms
64 bytes from 10.1.10.100: icmp_seq=3 ttl=61 time=320 ms
64 bytes from 10.1.10.100: icmp_seq=4 ttl=61 time=333 ms
--- 10.1.10.100 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 6088msms
```

```bash
ubuntu@aws-external-vm:~$ ping 10.200.100.100
PING 10.200.100.100 (10.200.100.100) 56(84) bytes of data.
64 bytes from 10.200.100.100: icmp_seq=1 ttl=61 time=312 ms
64 bytes from 10.200.100.100: icmp_seq=2 ttl=61 time=308 ms
64 bytes from 10.200.100.100: icmp_seq=3 ttl=61 time=306 ms
64 bytes from 10.200.100.100: icmp_seq=4 ttl=61 time=309 ms
--- 10.200.100.100 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 6030ms
```

```bash
ubuntu@aws-external-vm:~$ ping 10.2.10.100
PING 10.2.10.100 (10.2.10.100) 56(84) bytes of data.
--- 10.2.10.100 ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 6400ms
```

As we can see from the output, the connection is successful between the AWS External VM and AWS Prod VM. However, there is no connection between the AWS External VM and AWS Dev VM and other networks.

# 6. Data Flow Analysis

Now that we have established and tested the connection between the VPCs and VMware Data Center, we can take a look at data flow using the **Flow Analysis** tool. The tool provides a graphical way to visualize the volume of data flow between our workloads across the F5 Distributed Cloud fabric.

Back in the F5 Distributed Cloud Console, in the **Multi-Cloud Network Connect** service go to **Sites**. Click on the created site.

![alt text](./assets/site_navigate.png)

Next, navigate to the **Traffic Flows**.

![alt text](./assets/site_details.png)

Click on the **Table** to see the data flow in a table format.

![alt text](./assets/site_flow_graph.png)

Set **Source** to the IP address of the AWS External VM and **Destination** to **Site**. Click **Apply**.

![alt text](./assets/site_flow_table.png)

You can see the data flow between the AWS External VM and the AWS Prod VM. From the table, you can see that the http traffic is flowing between the two VMs. Let's create a firewall policy to allow only http traffic between the AWS External VM and the AWS Prod VM.

# 7. Firewall policies 
 
As we have seen in the last section with flow analysis, pings are also being generated from the external VPC to the Prod VPC in addition to the HTTP/HTTPs which is in alignment with our agreement with the external entity. We need to put a Zero Trust policy to ensure that workloads in the External VPC can only access the intended workload (10.1.10.100) on HTTP/HTTPs while denying all other traffic.
 
![alt text](./assets/firewall-overview.gif) 
 
## 7.1 Configure Firewall Policies 

In this part we will create and configure Firewall Policy with two rules - one to allow http traffic from external segment to the prod one, and another - to deny everything else. Then we will assign the policy to our AWS TGW Site and test it. In the **Multi-Cloud Network Connect** service navigate to **Firewall** and select **Enhanced Firewall Policies**. Click the **Add Enhanced Firewall Policy** button.

![alt text](./assets/xc_fw_open.png)

Give it a name.

![alt text](./assets/xc_fw_name.png)

In the **Rule** section, select **Custom Enhanced Firewall Policy Rule Selection** to configure the first rule.

![alt text](./assets/xc_fw_rule.png)

Proceed by clicking **Add Item**.

![alt text](./assets/xc_fw_rule_add.png)

First, let's give it an explanatory name, something like **allow-http-traffic**. Then, let's add some description. You can see an example in the image below. After that, open the **Action** drop-down menu to select **Allow**. And finally, select **IP Prefix List** for Source Traffic Filter.

![alt text](./assets/xc_fw_rule_add_http_name.png)

Let's now configure IPv4 Prefix List. Type in **10.150.0.0/16** and click **Apply**.

![alt text](./assets/xc_fw_rule_add_http_src.png)

Next, we will configure Destination Traffic Filter. Select **IPv4 Prefix List** and click **Configure**.

![alt text](./assets/xc_fw_rule_add_http_dst.png)

Type in **10.1.0.0/16** and click **Apply**.

![alt text](./assets/xc_fw_rule_add_http_dst_ip.png)

In the **Select Type of Traffic to Match** choose **Match Application Traffic** and add **HTTP** and **HTTPS**. Complete configuring the first rule by clicking **Apply**.

![alt text](./assets/xc_fw_rule_add_http_full.png)

Next we will add the second rule to deny everything else. Click the **Add Item** button.

![alt text](./assets/xc_fw_rule_add_deny.png)

Give it a name, take a look at the configuration and apply it.

![alt text](./assets/xc_fw_rule_add_deny_details.png)

Complete configuring the rules by clicking **Apply**.

![alt text](./assets/xc_fw_rule_add_apply.png)

Scroll down to the **Segment Selector** section. Select **Segments** for both - source and destination ones. Then choose **external-segment** we created earlier for the source, and **prod-segment** for the destination. Complete creating the Enhanced Firewall Policy by clicking **Save and Exit**.

![alt text](./assets/xc_fw_segments.png)

## 7.2 Assign Policies to AWS TGW Site

Now that the Enhanced Firewall Policy with two rules is created, we can assign it to our AWS TGW Site. Go to **Site Management** and select **AWS TGW Sites**. Open service menu of our site and choose **Manage Configuration**.

![alt text](./assets/xc_fw_aws_tgw.png)

Click **Edit Configuration** to enable the editing mode.

![alt text](./assets/xc_fw_aws_tgw_edit.png)

Scroll down to the **Site Network and Security** section and click **Configure** site security.

![alt text](./assets/xc_fw_aws_tgw_sec.png)

Select **Active Enhanced Firewall Policies** in the **Manage Firewall Policy** section and click **Configure**.

![alt text](./assets/xc_fw_aws_tgw_sec_enh.png)

In the drop-down menu select the policy we created and click **Apply**.

![alt text](./assets/xc_fw_aws_tgw_sec_sel.png)

Take a look at Security Policy configuration and **Apply** it.

![alt text](./assets/xc_fw_aws_tgw_sec_enh_apply.png)

Scroll to the bottom of the configuration page and complete assigning the policy to the site by clicking **Save and Exit**.

![alt text](./assets/xc_fw_aws_tgw_save.png)

## 7.3 Test connectivity between External VPC and Prod VPC

Repeat the test from the [previous step](#53-test-connectivity-between-external-vpc-and-prod-vpc) to check the connectivity between the AWS External VM and AWS Prod VM.

```bash
ubuntu@aws-external-vm:~$ ping 10.1.10.100
PING 10.1.10.100 (10.1.10.100) 56(84) bytes of data.
--- 10.1.10.100 ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 6400ms
```

The connection is not successful between the AWS External VM and AWS Prod VM. This means that the firewall policy is applied and the traffic is blocked.

Now, let's test the connection between the AWS External VM and the AWS Prod VM on port 80. To do that, we will use the curl command.

```bash
ubuntu@aws-external-vm:~$ curl http://10.1.10.100

<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

In the output, we can see the response from Nginx server running on the AWS Prod VM. This means that the connection is successful on port 80.

# 8. ExtraNet: App Centric Method

In this demo earlier we configured the L3 connection for traffic between prod segment and external segment. In this section we will add an HTTP Load Balancer that will let us expose L7 traffic from prod to external segment. To do that, we will first need to remove the external-to-prod segment connector, then create an HTTP LB and create an A DNS record.

![alt text](./assets/app-centric-overview.gif)

## 8.1 Remove External-Prod Segment Connector

Back in the F5 Distributed Cloud Console navigate to the **Multi-Cloud Network Connect** service. From there, navigate to **Networking** and select **Segment Connector**. Click the **Manage Segment Connections** button.

![alt text](./assets/app_connect_segment_remove.png)

Remove the external-to-prod segment connector and save the change.

![alt text](./assets/app_connect_segment_remove_apply.png)

## 8.2 Create HTTP LB

Next, we will create an HTTP Load Balancer. Open the main menu and select the **Multi-Cloud App Connect** service. 

![alt text](./assets/app_connect_navigate.png)

Select your namespace, navigate to **Load Balancers** and proceed to **HTTP Load Balancers**. Click the **Add HTTP Load Balancer** button.

![alt text](./assets/app_connect_navigate_add.png)

First, give LB a name.

![alt text](./assets/app_connect_httplb_name.png)

Then we will configure **Domains and LB Type** section. Type in the **prod-app.acme.internal** domain and select **HTTP** as Load Balancer Type.

![alt text](./assets/app_connect_httplb_domain.png)

Scroll down to the **Origins** section and add an origin pool by clickcing the **Add Item** button.

![alt text](./assets/app_connect_httplb_origin.png)

Open the **Origin Pool** drop-down menu and click **Add Item** to add an origin pool.

![alt text](./assets/app_connect_httplb_origin_add.png)

Give origin pool a name and add an origin server.

![alt text](./assets/app_connect_httplb_origin_name.png)

Select **IP address of Origin Server on given Sites** as Origin Server type and type in the **10.1.10.100** private IP. In the drop-down menu select the AWS TGW Site we created [earlier](#14-create-aws-tgw-site). Complete the configuration by selecting **Segment** network on the site. Select the **prod-segment** created [here](#21-configure-cloud-connect).

![alt text](./assets/app_connect_httplb_origin_details.png)

Type in the **80** origin server port and **Continue**.

![alt text](./assets/app_connect_httplb_origin_details_apply.png)

**Apply** origin pool configuration.

![alt text](./assets/app_connect_httplb_origin_apply.png)

Back on the HTTP configuration form, scroll down to **Other Settings** and select **Custom** for VIP Advertisement. 

![alt text](./assets/app_connect_httplb_origin_adv.png)

Click the **Add Item** button to configure List of Sites to Advertise the Load Balancer.

![alt text](./assets/app_connect_httplb_origin_adv_add.png)

Select **Segment on Site** to advertise on a segment on site. In the drop-down menus choose the External Company segment and the AWS TGW Site. Type in **10.1.10.90** for IP address to be used as VIP on the site. 

![alt text](./assets/app_connect_httplb_origin_adv_details.png)

**Apply** the Custom Advertise VIP Configuration configuration.

![alt text](./assets/app_connect_httplb_adv_apply.png)

Now that the HTTP Load Balancer is configured, click **Save and Exit** to save it. 

![alt text](./assets/app_connect_httplb_apply.png)

Finally, we will create an A record for the DNS we specified when creating the HTTP Load Balancer. Go to the AWS Management Console and proceed to **AWS Route 53**. Fill in the record name, select the **A** record type, type in the IP value we indicated to be used as VIP on the site and create the record.

![alt text](./assets/app_connect_dns.png)

## 8.3 Test connectivity

Go to the AWS External VM and run the following `curl` for the domain to the app from the external segment:

```bash
ubuntu@aws-external-vm:~$ curl http://prod-app.acme.internal

<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

As you can see from the output, the connection is successful and the app is accessible from the external segment.

Next, run the following `curl` for the direct connection and see from the output that there's no direct connection:

```bash
ubuntu@aws-external-vm:~$ curl http://10.1.10.100

curl: (28) Failed to connect to 10.1.10.100 port 80 after 134047 ms: Couldn't connect to **server**
```
