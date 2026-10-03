output "resource_group_name" {
  description = "Name of the Terraform-managed resource group."
  value       = azurerm_resource_group.main.name
}

output "virtual_network_name" {
  description = "Name of the virtual network."
  value       = module.network.vnet_name
}

output "frontend_private_ip" {
  description = "Private IP address of the frontend VM."
  value       = module.compute.frontend_private_ip
}

output "backend_private_ip" {
  description = "Private IP address of the backend VM."
  value       = module.compute.backend_private_ip
}

output "postgresql_fqdn" {
  description = "Fully qualified domain name of the PostgreSQL server."
  value       = module.database.postgresql_fqdn
}

output "database_name" {
  description = "Application database name."
  value       = module.database.postgresql_database_name
}
