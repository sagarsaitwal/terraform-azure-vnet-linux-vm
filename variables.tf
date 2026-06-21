variable "subscription_id" {
  description = "Azure subscription ID in which resources will be created."
  type        = string
}

variable "location" {
  description = "Azure region for the resource group and resources."
  type        = string
  default     = "Central India"
}

variable "project_name" {
  description = "Short lowercase name used in Azure resource names."
  type        = string
  default     = "terraform-demo"

  validation {
    condition     = can(regex("^[a-z0-9-]{2,30}$", var.project_name))
    error_message = "project_name must contain 2-30 lowercase letters, numbers, or hyphens."
  }
}

variable "virtual_network_cidr" {
  description = "Address space for the Azure Virtual Network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_cidrs" {
  description = "Address prefixes for subnets intended to host resources with public access."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Address prefixes for subnets intended to host private resources."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "enable_nat_gateway" {
  description = "Create an Azure NAT Gateway for outbound access from private subnets. This incurs Azure charges."
  type        = bool
  default     = false
}

variable "vm_size" {
  description = "Azure Virtual Machine size."
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Administrator username for the Linux VM."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "OpenSSH public key used to access the Linux VM. Never provide the private key."
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to connect to the VM on TCP port 22."
  type        = list(string)
  default     = []
}

variable "allowed_http_cidrs" {
  description = "CIDR blocks allowed to connect to the VM on TCP port 80."
  type        = list(string)
  default     = []
}

variable "os_disk_size_gb" {
  description = "Operating system disk size in GiB."
  type        = number
  default     = 30

  validation {
    condition     = var.os_disk_size_gb >= 30
    error_message = "os_disk_size_gb must be at least 30 GiB for the default Ubuntu image."
  }
}

variable "image_publisher" {
  description = "Publisher of the Azure Marketplace image."
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "Offer name of the Azure Marketplace image."
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "SKU of the Azure Marketplace image."
  type        = string
  default     = "22_04-lts-gen2"
}

variable "image_version" {
  description = "Version of the Azure Marketplace image."
  type        = string
  default     = "latest"
}

variable "custom_data" {
  description = "Optional cloud-init content. The VM module base64-encodes this value."
  type        = string
  default     = null
  nullable    = true
}

variable "common_tags" {
  description = "Tags applied to all supported Azure resources."
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

