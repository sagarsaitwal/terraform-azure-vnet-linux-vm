output "virtual_network_id" {
  description = "Resource ID of the Virtual Network."
  value       = azurerm_virtual_network.this.id
}

output "virtual_network_name" {
  description = "Name of the Virtual Network."
  value       = azurerm_virtual_network.this.name
}

output "public_subnet_ids" {
  description = "Public subnet IDs in input order."
  value = [
    for index in range(length(var.public_subnet_cidrs)) :
    azurerm_subnet.public[tostring(index)].id
  ]
}

output "private_subnet_ids" {
  description = "Private subnet IDs in input order."
  value = [
    for index in range(length(var.private_subnet_cidrs)) :
    azurerm_subnet.private[tostring(index)].id
  ]
}

output "nat_gateway_id" {
  description = "NAT Gateway resource ID, or null when disabled."
  value       = try(azurerm_nat_gateway.this[0].id, null)
}

