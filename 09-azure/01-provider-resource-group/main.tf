terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "terraform-azure-lab-rg"
  location = "Central India"
  tags = {
    Owner      = "tarun"
    AutoDelete = "yes"
  }
}

output "resource_group_id" {
  value = azurerm_resource_group.example.id
}
