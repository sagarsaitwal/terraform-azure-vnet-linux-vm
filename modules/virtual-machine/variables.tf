variable "project_name" {
  description = "Name prefix for Virtual Machine resources."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group."
  type        = string
}

variable "location" {
  description = "Azure region for Virtual Machine resources."
  type        = string
}

variable "subnet_id" {
  description = "Resource ID of the subnet used by the network interface."
  type        = string
}

variable "vm_size" {
  description = "Azure Virtual Machine size."
  type        = string
}

variable "admin_username" {
  description = "Administrator username for the Linux VM."
  type        = string
}

variable "ssh_public_key" {
  description = "OpenSSH public key for administrator access."
  type        = string
}

variable "create_public_ip" {
  description = "Create and attach a Public IP Address."
  type        = bool
  default     = true
}

variable "allowed_ssh_cidrs" {
  description = "CIDRs allowed to connect using SSH."
  type        = list(string)
  default     = []
}

variable "allowed_http_cidrs" {
  description = "CIDRs allowed to connect using HTTP."
  type        = list(string)
  default     = []
}

variable "os_disk_size_gb" {
  description = "Operating system disk size in GiB."
  type        = number
  default     = 30
}

variable "image_publisher" {
  description = "Azure Marketplace image publisher."
  type        = string
}

variable "image_offer" {
  description = "Azure Marketplace image offer."
  type        = string
}

variable "image_sku" {
  description = "Azure Marketplace image SKU."
  type        = string
}

variable "image_version" {
  description = "Azure Marketplace image version."
  type        = string
}

variable "custom_data" {
  description = "Optional cloud-init content."
  type        = string
  default     = null
  nullable    = true
}

variable "tags" {
  description = "Additional tags for Virtual Machine resources."
  type        = map(string)
  default     = {}
}

