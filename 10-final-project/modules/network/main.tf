resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space

  tags = var.common_tags
}

resource "azurerm_subnet" "main" {
  for_each = local.subnets

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [each.value.cidr]
}

resource "azurerm_network_security_group" "main" {
  for_each = local.nsgs

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = each.value.rules
    iterator = rule

    content {
      name                       = rule.value.name
      priority                   = rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = rule.value.destination_port_range
      source_address_prefix      = try(rule.value.source_address_prefix, "*")
      destination_address_prefix = "*"
    }
  }

  tags = var.common_tags
}

resource "azurerm_subnet_network_security_group_association" "main" {
  for_each = local.subnets

  subnet_id                 = azurerm_subnet.main[each.key].id
  network_security_group_id = azurerm_network_security_group.main[each.key].id
}