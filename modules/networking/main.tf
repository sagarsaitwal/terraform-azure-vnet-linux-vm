locals {
  public_subnets = {
    for index, cidr in var.public_subnet_cidrs : tostring(index) => cidr
  }

  private_subnets = {
    for index, cidr in var.private_subnet_cidrs : tostring(index) => cidr
  }
}

resource "azurerm_virtual_network" "this" {
  name                = "${var.project_name}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.virtual_network_cidr
  tags                = var.tags
}

resource "azurerm_subnet" "public" {
  for_each = local.public_subnets

  name                 = "${var.project_name}-public-snet-${tonumber(each.key) + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value]
}

resource "azurerm_subnet" "private" {
  for_each = local.private_subnets

  name                 = "${var.project_name}-private-snet-${tonumber(each.key) + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value]
}

resource "azurerm_public_ip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0

  name                = "${var.project_name}-nat-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_nat_gateway" "this" {
  count = var.enable_nat_gateway ? 1 : 0

  name                    = "${var.project_name}-nat-gateway"
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  tags                    = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  count = var.enable_nat_gateway ? 1 : 0

  nat_gateway_id       = azurerm_nat_gateway.this[0].id
  public_ip_address_id = azurerm_public_ip.nat[0].id
}

resource "azurerm_subnet_nat_gateway_association" "private" {
  for_each = var.enable_nat_gateway ? azurerm_subnet.private : {}

  subnet_id      = each.value.id
  nat_gateway_id = azurerm_nat_gateway.this[0].id
}

