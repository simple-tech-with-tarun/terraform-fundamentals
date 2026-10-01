resource "azurerm_private_dns_zone" "postgresql" {
  name                = "terraform-azure-final.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.example.name

  tags = {
    AutoDelete = "yes"
    Owner      = "tarun"
  }
}
resource "azurerm_private_dns_zone_virtual_network_link" "postgresql" {
  name                = "postgresql-dns-link"
  private_dns_zone_id = azurerm_private_dns_zone.postgresql.id
  virtual_network_id  = azurerm_virtual_network.example.id

  tags = {
    AutoDelete = "yes"
    Owner      = "tarun"
  }
}

resource "azurerm_postgresql_flexible_server" "example" {
  name                          = "terraform-azure-final-postgres"
  resource_group_name           = azurerm_resource_group.example.name
  location                      = azurerm_resource_group.example.location
  version                       = "16"
  zone                          = "2"
  delegated_subnet_id           = azurerm_subnet.database.id
  private_dns_zone_id           = azurerm_private_dns_zone.postgresql.id
  public_network_access_enabled = false

  administrator_login    = "pgadmin"
  administrator_password = var.postgres_admin_password

  storage_mb            = 32768
  sku_name              = "B_Standard_B1ms"
  backup_retention_days = 7

  tags = {
    AutoDelete = "yes"
    Owner      = "tarun"
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.postgresql
  ]
}
resource "azurerm_postgresql_flexible_server_database" "app" {
  name      = "appdb"
  server_id = azurerm_postgresql_flexible_server.example.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}
output "postgresql_fqdn" {
  value = azurerm_postgresql_flexible_server.example.fqdn
}
