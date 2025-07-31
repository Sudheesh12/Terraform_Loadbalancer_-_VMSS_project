# Terraform_Loadbalancer_-_VMSS_project

A Terraform project to deploy an Azure Load Balancer with an Orchestrated Virtual Machine Scale Set (VMSS).

## Project Overview

- Creates an Azure Resource Group with location validation.
- Deploys a Virtual Network with two subnets: Application and Management.
- Sets up a Standard Azure Load Balancer with a public IP address.
- Deploys an Orchestrated VMSS running Ubuntu 22.04 with SSH key authentication.
- Implements autoscaling based on CPU usage.
- Applies consistent tagging for all resources.

## Prerequisites

- Terraform v1.0 or higher installed.
- Azure CLI installed and authenticated to your subscription.
- Permission to create resources in your Azure subscription.

## How to Use

1. Clone the repository:

   ```bash
   git clone https://github.com/Sudheesh12/Terraform_Loadbalancer_-_VMSS_project.git
   cd Terraform_Loadbalancer_-_VMSS_project
   ```

2. Initialize Terraform:

   ```bash
   terraform init
   ```

3. Review and update variables in `variables.tf` or via Terraform CLI options as needed.

4. Apply the Terraform configuration to create resources:

   ```bash
   terraform apply
   ```

5. Confirm resources are created successfully.

## Important Notes on SSH Access

- The `azurerm_orchestrated_virtual_machine_scale_set` resource does not currently support direct association of inbound NAT rules for SSH access via the load balancer.
- To access VMSS instances over SSH, use **Azure Bastion** or deploy a **jumpbox VM** inside the virtual network.
- Avoid exposing SSH ports directly; these approaches improve security and align with Azure best practices.

## Further Customization & Troubleshooting

- Adjust autoscale settings in the `azurerm_monitor_autoscale_setting` resource as needed.
- For troubleshooting SSH or network connectivity:
  - Check Network Security Group rules to allow inbound SSH traffic.
  - Validate load balancer frontend IP configurations.
  - Ensure VMSS instances are running and healthy.
