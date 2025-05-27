Administering private VMs with Azure Bastion example
=================

In this project I tried to recreate a patter in Azure from AWS where EC2
instances are in a private subnet, connect to the outside internet with NAT
Gateway (or not) and user administers them using SSM Session Manager (via VPC
Endpoints).

This pattern is not possible to directly create in Azure but I tried my best.

For more information, see my blog post:

- [https://pabis.eu/blog/2025-06-10-Session-Manager-Equivalent-Azure-Bastion.html](https://pabis.eu/blog/2025-06-10-Session-Manager-Equivalent-Azure-Bastion.html)

It does the following:

- create a sample Virtual Machine with Ubuntu in a private subnet,
- let the VM access the internet via a NAT Gateway,
- create Azure Bastion to administer the instance,
- create unique SSH key pair to use for the instance,
- store the SSH key in Azure Key Vault,
- set appropriate permissions in AKV,
- add Network Security Group to limit the exposure of ports of Bastion and VMs.
