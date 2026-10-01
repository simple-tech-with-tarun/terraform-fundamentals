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
