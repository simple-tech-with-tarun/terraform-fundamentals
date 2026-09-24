terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

module "file" {
  source    = "./modules/file"
  file_name = "custom-module.txt"
  content   = "custom-module-txt"
}

output "file_name" {
  value = module.file.filename
}

output "content" {
  value = module.file.content
}
