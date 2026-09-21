resource "azurerm_resource_group" "dynamic_lab" {
  for_each = var.rg
  name     = each.value.name
  location = each.value.location
  tags     = each.value.tags


}

resource "azurerm_network_security_group" "dynamic_lab" {
  depends_on          = [azurerm_resource_group.dynamic_lab]
  for_each            = var.nsg
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.rg_name

  dynamic "security_rule" {
    for_each = each.value.rule
    iterator = rule
    content {
      name                       = rule.value.name
      priority                   = rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = rule.value.destination_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

}
