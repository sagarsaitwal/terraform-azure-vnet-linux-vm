resource "azurerm_resource_group" "this" {
  name     = "${var.project_name}-rg"
  location = var.location
  tags     = var.common_tags
}

module "networking" {
  source = "./modules/networking"

  project_name         = var.project_name
  resource_group_name  = azurerm_resource_group.this.name
  location             = azurerm_resource_group.this.location
  virtual_network_cidr = var.virtual_network_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  tags                 = var.common_tags
}

module "virtual_machine" {
  source = "./modules/virtual-machine"

  project_name        = var.project_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = module.networking.public_subnet_ids[0]
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  create_public_ip    = true
  allowed_ssh_cidrs   = var.allowed_ssh_cidrs
  allowed_http_cidrs  = var.allowed_http_cidrs
  os_disk_size_gb     = var.os_disk_size_gb
  image_publisher     = var.image_publisher
  image_offer         = var.image_offer
  image_sku           = var.image_sku
  image_version       = var.image_version
  custom_data         = var.custom_data
  tags                = var.common_tags
}

