output "frontend_private_ip" {
  description = "Private IP address assigned to the frontend VM."
  value       = azurerm_network_interface.main["frontend"].private_ip_address
}

output "backend_private_ip" {
  description = "Private IP address assigned to the backend VM."
  value       = azurerm_network_interface.main["backend"].private_ip_address
}

output "frontend_vm_id" {
  description = "ID of the frontend virtual machine."
  value       = azurerm_linux_virtual_machine.main["frontend"].id
}

output "backend_vm_id" {
  description = "ID of the backend virtual machine."
  value       = azurerm_linux_virtual_machine.main["backend"].id
}