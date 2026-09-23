terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "backup" {
  name     = "terraform-state-backup-rg"
  location = "Central India"

  tags = {
    owner       = "tarun"
    environment = "lab"
  }
}