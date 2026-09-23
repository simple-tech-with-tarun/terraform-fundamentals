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

resource "azurerm_resource_group" "imported" {
  name     = "terraform-state-import-rg"
  location = "Central India"
  tags = {
    owner      = "tarun"
    AutoDelete = "Yes"
  }
}
