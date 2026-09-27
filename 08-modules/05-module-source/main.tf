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
 module "GitHub_module" {
    source = "git::https://github.com/simple-tech-with-tarun/terraform-module-source-lab.git"
 }

module "GitHub_secondary_module" {
  source = "git::https://github.com/simple-tech-with-tarun/terraform-module-source-lab.git//modules/secondary"
}
