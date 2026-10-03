variable "resource_group_name" {
  description = "Name of the resource group where database resources are created."
  type        = string
}

variable "location" {
  description = "Azure region where database resources are created."
  type        = string
}

variable "database_subnet_id" {
  description = "ID of the delegated subnet used by PostgreSQL Flexible Server."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to database resources."
  type        = map(string)
}

variable "administrator_login" {
  description = "Administrator username for PostgreSQL."
  type        = string
}

variable "administrator_password" {
  description = "Administrator password for PostgreSQL."
  type        = string
  sensitive   = true
}

variable "vnet_id" {
  description = "ID of the virtual network linked to the private DNS zone."
  type        = string
}
