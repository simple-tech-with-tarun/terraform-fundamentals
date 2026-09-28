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

data "azurerm_resource_group" "lab" {
  name = "terraform-azure-lab-rg"
}

resource "azurerm_storage_account" "example" {
  name                     = "tfazlabstorage01"
  resource_group_name      = data.azurerm_resource_group.lab.name
  location                 = data.azurerm_resource_group.lab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    AutoDelete = "yes"
    Owner      = "tarun"
  }
}