terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

variable "environments" {
  type = map(string)

  default = {
    dev  = "Development"
    test = "Testing"
    prod = "Production"
  }
}

resource "local_file" "resource_group" {
  filename = "resource-group.txt"
  content  = "Resource Group: terraform-meta-arguments"
}

resource "local_file" "environment" {
  for_each = var.environments

  depends_on = [local_file.resource_group]

  filename = "${each.key}.txt"
  content  = "Environment: ${each.value}"
}