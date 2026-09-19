terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

variable "environment" {
  type    = string
  default = "dev"
}

output "environment_upper" {
  value = upper(var.environment)
}

output "is_production" {
  value = var.environment == "prod"
}

output "env" {
  value = var.environment == "prod" ? "Production" : "Development"
}

output "not_production" {
  value = var.environment != "prod"
}

output "environment_is_dev" {
  value = var.environment == "dev"
}

output "is_test_or_dev" {
  value = var.environment == "test" || var.environment == "dev"
}

output "is_prod_and_dev" {
  value = (var.environment == "prod" && var.environment == "dev") ? var.environment : "yes"
}

output "not_dev" {
  value = !(var.environment == "dev")
}
