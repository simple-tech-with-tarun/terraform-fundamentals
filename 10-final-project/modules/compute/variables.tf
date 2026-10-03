variable "resource_group_name" {
  description = "Name of the resource group where compute resources are created."
  type        = string
}

variable "location" {
  description = "Azure region where compute resources are created."
  type        = string
}

variable "frontend_subnet_id" {
  description = "ID of the frontend subnet."
  type        = string
}

variable "backend_subnet_id" {
  description = "ID of the backend subnet."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to compute resources."
  type        = map(string)
}
variable "ssh_public_key_path" {
  description = "Path to the SSH public key used for Linux VM access."
  type        = string
}