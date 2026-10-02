variable "resource_group_name" {
  description = "Name of the Azure resource group."
  type        = string
  default     = "terraform-final-project-rg"
}

variable "location" {
  description = "Azure region where resources will be deployed."
  type        = string
  default     = "Central India"
}

variable "project_name" {
  description = "Name used to identify resources created by the project."
  type        = string
  default     = "terraform-final-project"
}

variable "vnet_address_space" {
  description = "Address space for the project virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "frontend_subnet_cidr" {
  description = "Address range for the frontend subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "backend_subnet_cidr" {
  description = "Address range for the backend subnet."
  type        = string
  default     = "10.0.2.0/24"
}

variable "database_subnet_cidr" {
  description = "Address range for the database subnet."
  type        = string
  default     = "10.0.3.0/24"
}