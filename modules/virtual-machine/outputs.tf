output "virtual_machine_id" {
  description = "Resource ID of the Linux Virtual Machine."
  value       = azurerm_linux_virtual_machine.this.id
}

output "virtual_machine_name" {
  description = "Name of the Linux Virtual Machine."
  value       = azurerm_linux_virtual_machine.this.name
}

output "public_ip_address" {
  description = "Public IPv4 address, or null when no Public IP is created."
  value       = try(azurerm_public_ip.vm[0].ip_address, null)
}

output "private_ip_address" {
  description = "Private IPv4 address of the network interface."
  value       = azurerm_network_interface.this.private_ip_address
}

output "network_interface_id" {
  description = "Resource ID of the network interface."
  value       = azurerm_network_interface.this.id
}

output "network_security_group_id" {
  description = "Resource ID of the Network Security Group."
  value       = azurerm_network_security_group.this.id
}

