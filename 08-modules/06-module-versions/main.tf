terraform {
  required_version = ">= 1.9, < 2.0"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

module "resource_group" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "< 0.4"

  name     = "terraform-module-version-lab-rg"
  location = "Central India"
  tags = {
    Owner      = "tarun"
    AutoDelete = "yes"
  }
}
