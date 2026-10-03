resource "azurerm_postgresql_flexible_server" "main" {
  depends_on = [azurerm_private_dns_zone_virtual_network_link.main]

  name                   = local.server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  zone                   = "1"
  version                = "16"
  delegated_subnet_id    = var.database_subnet_id
  private_dns_zone_id    = azurerm_private_dns_zone.main.id
  administrator_login    = local.administrator_login
  administrator_password = var.administrator_password

  public_network_access_enabled = false

  sku_name = "B_Standard_B1ms"

  storage_mb = 32768

  backup_retention_days = 7

  tags = var.common_tags
}

resource "azurerm_private_dns_zone" "main" {
  name                = local.dns_zone_name
  resource_group_name = var.resource_group_name

  tags = var.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                = "${local.server_name}-dns-link"
  private_dns_zone_id = azurerm_private_dns_zone.main.id
  virtual_network_id  = var.vnet_id

}
resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = local.database_name
  server_id = azurerm_postgresql_flexible_server.main.id

  lifecycle {
    prevent_destroy = true
  }
}
