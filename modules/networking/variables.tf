variable "project_name" {
  description = "Name prefix for networking resources."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group."
  type        = string
}

variable "location" {
  description = "Azure region for networking resources."
  type        = string
}

variable "virtual_network_cidr" {
  description = "Address spaces assigned to the Virtual Network."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Address prefixes for the public subnet group."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) > 0
    error_message = "Provide at least one public subnet CIDR."
  }
}

variable "private_subnet_cidrs" {
  description = "Address prefixes for the private subnet group."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Create and associate a NAT Gateway with private subnets."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags for networking resources."
  type        = map(string)
  default     = {}
}

