variable "resource_group_name" {
  description = "Name of the resource group where network resources are created."
  type        = string
}

variable "location" {
  description = "Azure region where network resources are created."
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network."
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
}

variable "frontend_subnet_name" {
  description = "Name of the frontend subnet."
  type        = string
}

variable "frontend_subnet_cidr" {
  description = "CIDR range for the frontend subnet."
  type        = string
}

variable "backend_subnet_name" {
  description = "Name of the backend subnet."
  type        = string
}

variable "backend_subnet_cidr" {
  description = "CIDR range for the backend subnet."
  type        = string
}

variable "database_subnet_name" {
  description = "Name of the database subnet."
  type        = string
}

variable "database_subnet_cidr" {
  description = "CIDR range for the database subnet."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to network resources."
  type        = map(string)
}