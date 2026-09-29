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

resource "azurerm_storage_account" "managed_identity" {
  name                     = "tfazlabidentity01"
  resource_group_name      = data.azurerm_resource_group.lab.name
  location                 = data.azurerm_resource_group.lab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.example.id
    ]
  }

  tags = {
    AutoDelete = "yes"
    Owner      = "tarun"
  }
}

output "storage_account_id" {
  value = azurerm_storage_account.managed_identity.id
}

output "principal_id" {
  value = azurerm_storage_account.managed_identity.identity[0].principal_id
}

output "tenant_id" {
  value = azurerm_storage_account.managed_identity.identity[0].tenant_id
}

resource "azurerm_user_assigned_identity" "example" {
  name                = "terraform-azure-user-identity"
  resource_group_name = data.azurerm_resource_group.lab.name
  location            = data.azurerm_resource_group.lab.location

  tags = {
    AutoDelete = "yes"
    Owner      = "tarun"
  }
}

output "user_assigned_identity_id" {
  value = azurerm_user_assigned_identity.example.id
}

output "user_assigned_principal_id" {
  value = azurerm_user_assigned_identity.example.principal_id
}

output "user_assigned_client_id" {
  value = azurerm_user_assigned_identity.example.client_id
}
