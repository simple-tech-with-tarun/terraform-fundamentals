terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-remote-state-rg"
    storage_account_name = "tfstatelab20260923"
    container_name       = "tfstate"
    key                  = "consumer.tfstate"
  }

  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

data "terraform_remote_state" "source" {
  backend = "azurerm"

  config = {
    resource_group_name  = "terraform-remote-state-rg"
    storage_account_name = "tfstatelab20260923"
    container_name       = "tfstate"
    key                  = "source.tfstate"
  }
}

output "source_filename" {
  value = data.terraform_remote_state.source.outputs.source_filename
}

output "source_content" {
  value = data.terraform_remote_state.source.outputs.source_content
}

output "source_id" {
  value = data.terraform_remote_state.source.outputs.source_id
}
