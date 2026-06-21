output "resource_group_name" {
  description = "Name of the Azure Resource Group."
  value       = azurerm_resource_group.this.name
}

output "virtual_network_id" {
  description = "Resource ID of the Azure Virtual Network."
  value       = module.networking.virtual_network_id
}

output "public_subnet_ids" {
  description = "Resource IDs of the public subnet group."
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Resource IDs of the private subnet group."
  value       = module.networking.private_subnet_ids
}

output "virtual_machine_id" {
  description = "Resource ID of the Linux Virtual Machine."
  value       = module.virtual_machine.virtual_machine_id
}

output "virtual_machine_public_ip" {
  description = "Public IPv4 address assigned to the Virtual Machine."
  value       = module.virtual_machine.public_ip_address
}

output "virtual_machine_private_ip" {
  description = "Private IPv4 address assigned to the network interface."
  value       = module.virtual_machine.private_ip_address
}

output "network_security_group_id" {
  description = "Resource ID of the Network Security Group."
  value       = module.virtual_machine.network_security_group_id
}

