output "vnet_id" {
  description = "ID of the virtual network."
  value       = azurerm_virtual_network.main.id
}
output "vnet_name" {
  description = "ID of the virtual network."
  value       = azurerm_virtual_network.main.name
}
output "frontend_subnet_id" {
  description = "ID of the frontend subnet."
  value       = azurerm_subnet.main["frontend"].id
}

output "backend_subnet_id" {
  description = "ID of the backend subnet."
  value       = azurerm_subnet.main["backend"].id
}

output "database_subnet_id" {
  description = "ID of the database subnet."
  value       = azurerm_subnet.main["database"].id
}
