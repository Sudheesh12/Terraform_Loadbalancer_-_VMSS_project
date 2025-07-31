# Terraform_Loadbalancer_-_VMSS_project
A mini Terraform project on the Azure Load balancer and Virtual machine scale set.

---

## What i have created for now.

- created a resource group with a validation block of allowed location -East US, West Europe, Southeast Asia 
- created a random name generator with prefix and length one and assign to the name resource.
- created a local map for common tags and assigned it all the resources.
- created a vnet.
- created 2 application and management subnets separately and assigned it to the vnet
- created a public IP
- created a load-balancer and assigned public ip to the load balancer.
- 