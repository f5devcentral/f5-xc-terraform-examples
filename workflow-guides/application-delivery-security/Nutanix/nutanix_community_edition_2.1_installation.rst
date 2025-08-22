Installation of Nutanix Community Edition 2.1 on Bare Metal
==========================================================================

Introduction:
***************
Nutanix Community Edition (CE) 2.1 is a community supported version of Nutanix’s hyperconverged software. It allows to deploy and testing new workloads using Nutanix’s Acropolis Hypervisor (AHV). AHV offers an intuitive and easy way to manage virtual environments with optimized performance and reliability.

Recommended Hardware:
***************
Below are the following hardware requirements for running CE in our environment, 

* CPU: Intel Sandy Bridge (VT-x or AVX), or AMX Zen or later, 4 cores minimum
* Memory: 32 GB minimum, 64 GB or greater recommended 
* NIC: Intel or Realtek, 1 GbE or 2.5 GbE 

* HBA: AHCI SATA or LSI Controller with IT mode (best) or IR mode (Passthrough or Raid-O) 

* Storage device: Data disk with 500 GB minimum, 18 TB maximum (can be SSD or HDD) 

* Storage device: CVM (hot-tier flash) with 200 GB minimum (must be SSD) 

* Hypervisor Boot Disk: 32GB minimum (for external drives, use USB 3.0) 

* Imaging Software: Open-source imaging software such as Rufus. 

Reference page for `Recommended Hardware for Community Edition <https://portal.nutanix.com/page/documents/details?targetId=Nutanix-Community-Edition-Getting-Started-v2_1:top-sysreqs-ce-r.html>`__ section. 

My setup:
***************

For my setup, I installed single node cluster on Dell PowerEdge R430 with Intel NIC with following specs,

* CPU: 2 x Intel® Xeon® CPU E5-2620 v4 

* Memory: 64 GB 

* NIC: Intel NIC 10 GbE 4P X710 Adapter 

* HBA: AHCI SATA 

* Storage device: Data disk of SSD with 800 GB 

* Storage device: CVM of SSD with 800 GB 

* Hypervisor Boot disk: 32 GB USB 3.0 device 

* Imaging Software: Nutanix ISO booted using Rufus to USB 3.0 drive 

.. figure:: Assets/Nutanix_Dell_PowerEdge_overview.jpeg