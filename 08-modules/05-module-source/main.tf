terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

module "file_generator" {
  source = "./modules/file_generator"
}
