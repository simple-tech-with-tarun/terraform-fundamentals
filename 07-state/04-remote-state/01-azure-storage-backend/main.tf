terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-remote-state-rg"
    storage_account_name = "tfstatelab20260923"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }

  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "remote_state_test" {
  filename = "remote-state-test.txt"
  content  = "This state was updated remotely."
}
