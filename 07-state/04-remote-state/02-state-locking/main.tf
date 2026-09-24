terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-remote-state-rg"
    storage_account_name = "tfstatelab20260923"
    container_name       = "tfstate"
    key                  = "locking-test.tfstate"
  }

  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "locking_test" {
  filename = "locking-test.txt"
  content  = "Testing Terraform state locking - lock disabled."
}
