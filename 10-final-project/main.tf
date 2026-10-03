resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Owner      = "tarun"
    AutoDelete = "yes"
  }
}

module "network" {
  source = "./modules/network"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  vnet_name          = local.vnet_name
  vnet_address_space = var.vnet_address_space

  frontend_subnet_name = local.frontend_subnet_name
  frontend_subnet_cidr = var.frontend_subnet_cidr

  backend_subnet_name = local.backend_subnet_name
  backend_subnet_cidr = var.backend_subnet_cidr

  database_subnet_name = local.database_subnet_name
  database_subnet_cidr = var.database_subnet_cidr

  common_tags = local.common_tags
}

module "compute" {
  source = "./modules/compute"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  frontend_subnet_id = module.network.frontend_subnet_id
  backend_subnet_id  = module.network.backend_subnet_id

  ssh_public_key_path = var.ssh_public_key_path

  common_tags = local.common_tags
}

module "database" {
  source = "./modules/database"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  database_subnet_id = module.network.database_subnet_id
  vnet_id            = module.network.vnet_id

  administrator_login    = var.postgresql_admin_username
  administrator_password = var.postgresql_admin_password

  common_tags = local.common_tags
}