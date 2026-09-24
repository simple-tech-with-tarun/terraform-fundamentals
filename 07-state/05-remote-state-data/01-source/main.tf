terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-remote-state-rg"
    storage_account_name = "tfstatelab20260923"
    container_name       = "tfstate"
    key                  = "source.tfstate"
  }

  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "source" {
  filename = "source.txt"
  content  = "This file belongs to the source state."
}

output "source_filename" {
  value = local_file.source.filename
}

output "source_content" {
  value = local_file.source.content
}
output "source_id" {
  value = local_file.source.id
}
