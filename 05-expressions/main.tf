terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "environment" {
  filename = "environment.txt"

  content = var.environment == "prod" ? "Production environment" : "Non-production environment"
}
