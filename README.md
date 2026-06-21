# Azure Virtual Network and Linux VM with Terraform

This repository is a readable Terraform starter project for Microsoft Azure. It creates a Resource Group, Virtual Network, public and private subnet groups, optional NAT Gateway, Network Security Group, Public IP Address, network interface, and Linux Virtual Machine.

The project is split into modules so that networking and compute resources can be understood and changed independently. It is suitable as a learning project or starting template, but it has not been deployed to a live Azure subscription.

> Review security, availability, monitoring, backup, governance, and cost requirements before using this design for production.

## Azure terminology used here

| AWS term | Azure equivalent used in this project |
|---|---|
| Account | Subscription |
| Region | Location |
| VPC | Virtual Network (VNet) |
| Subnet | Subnet |
| EC2 instance | Azure Virtual Machine |
| Security Group | Network Security Group (NSG) |
| Elastic Network Interface | Network Interface (NIC) |
| Elastic IP | Public IP Address |
| AMI | Azure Marketplace image reference |
| Tags | Tags |

Azure subnets are not inherently public or private. This template uses those labels to describe intent. Actual reachability depends on Public IP associations, routes, NAT, Network Security Groups, and other network controls.

## What the template creates

- One Azure Resource Group
- One Virtual Network
- Two public-purpose subnets by default
- Two private-purpose subnets by default
- An optional NAT Gateway for private-subnet outbound traffic
- One Network Security Group with optional SSH and HTTP rules
- One static Standard Public IP Address for the VM
- One Network Interface
- One Linux Virtual Machine using an Ubuntu Marketplace image by default
- One managed Standard HDD operating system disk
- Managed boot diagnostics

## Project structure

```text
.
|-- main.tf
|-- providers.tf
|-- versions.tf
|-- variables.tf
|-- outputs.tf
|-- terraform.tfvars.example
|-- modules/
|   |-- networking/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   `-- outputs.tf
|   `-- virtual-machine/
|       |-- main.tf
|       |-- variables.tf
|       `-- outputs.tf
`-- README.md
```

The root module creates the Resource Group and connects the child modules. The networking module returns subnet resource IDs, and the virtual-machine module uses the first public subnet automatically.

## Prerequisites

For local formatting and validation:

- Terraform 1.5 or later

For planning or deploying to Azure:

- An Azure subscription
- Permission to create the resources in this template
- Azure CLI installed
- An OpenSSH public/private key pair

Never commit Azure credentials or a private SSH key to this repository.

## Configure the project

Open PowerShell in the project folder and copy the example values:

```powershell
Set-Location "D:\Terraform-azure"
Copy-Item terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`. Replace the subscription ID, SSH public key, allowed SSH CIDR, tags, and any naming or address values you want to customize.

Important notes:

- `subscription_id` must identify the subscription you are authorized to use.
- `ssh_public_key` must contain a public key such as the contents of `id_ed25519.pub`, never the private key.
- Replace the example SSH source with your public IP followed by `/32`.
- Never use `0.0.0.0/0` for SSH.
- Leave `allowed_ssh_cidrs = []` to create no SSH allow rule.
- Enabling the NAT Gateway creates chargeable Azure resources.
- Address ranges must not overlap and must fit inside the Virtual Network address space.

## Validate without an Azure account

You can publish and review this code without Azure credentials. After installing Terraform, run:

```powershell
terraform init -backend=false
terraform fmt -recursive
terraform validate
```

These commands initialize the provider, format the code, and validate its structure. Do not run `terraform plan` or `terraform apply` without an authorized Azure subscription.

## Authenticate and deploy when authorized

Sign in and select a subscription:

```powershell
az login
az account list --output table
az account set --subscription "YOUR_SUBSCRIPTION_ID"
az account show
```

Then run:

```powershell
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out main.tfplan
terraform apply main.tfplan
```

Review the plan carefully before applying it. Confirm the subscription, Location, address ranges, VM size, image, public access rules, and estimated Azure cost.

## Connect to the VM

After deployment, obtain the Public IP Address:

```powershell
terraform output -raw virtual_machine_public_ip
```

Connect using the private key that matches the configured public key:

```powershell
ssh -i "C:\path\to\your-private-key" azureuser@PUBLIC_IP
```

Opening port 80 in the NSG does not install a web server. Use `custom_data` cloud-init or configure the VM after launch if you want it to serve HTTP traffic.

## Remove the environment

When authorized and finished with the environment:

```powershell
terraform plan -destroy
terraform destroy
```

Review the destroy plan before confirming. The Resource Group contains the template resources, but Terraform still manages and deletes them individually through its state.

## State and repository safety

- Do not commit `terraform.tfstate`, plan files, or a real `terraform.tfvars` file.
- Do not place client secrets, access tokens, passwords, or private SSH keys in Terraform files.
- Do not edit Terraform state manually.
- Use an Azure Storage backend with state locking and restricted access for team environments.
- Commit `.terraform.lock.hcl` after `terraform init` so provider selections are reproducible.

## Cost considerations

Potential charges include Virtual Machine runtime, managed disk storage, Public IPv4 usage, NAT Gateway usage and processed data, and network data transfer. NAT is disabled by default. Destroy temporary environments when they are no longer required.

## Common problems

### Terraform cannot build the AzureRM provider

Run `terraform init` and confirm that your network permits access to the Terraform Registry.

### Azure authentication fails

Run `az login`, select the correct subscription, and confirm it with `az account show`. For automated workflows, use an approved service principal or workload identity rather than personal credentials.

### The VM size is unavailable

Not every VM size is offered in every Location or subscription. Choose a size available to your subscription in the configured Location.

### The Marketplace image is unavailable

Image publisher, offer, SKU, and version values must form a valid image reference in the selected Location.

### SSH times out

Confirm the VM has a Public IP Address, the NSG allows your current public IP on port 22, and the username and private key match the configured values.

## Useful next improvements

- Place application VMs in private subnets
- Use Azure Bastion or Azure Network Watcher instead of public SSH
- Add Azure Load Balancer or Application Gateway
- Add Virtual Machine Scale Sets
- Add availability zones where supported
- Store Terraform state in an Azure Storage Account
- Add Log Analytics, Azure Monitor alerts, and Network Watcher
- Add least-privilege role assignments and Azure Policy
- Run Terraform formatting and validation in CI

