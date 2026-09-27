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
# module "GitHub_module" {
#   source = "git::https://github.com/simple-tech-with-tarun/terraform-module-source-lab.git"
# }

# module "GitHub_secondary_module" {
#   source = "git::https://github.com/simple-tech-with-tarun/terraform-module-source-lab.git//modules/secondary?ref=v3.0.0"
# }
# module "GitHub_module_v2" {
#   source = "git::https://github.com/simple-tech-with-tarun/terraform-module-source-lab.git?ref=v2.0.1"
# }
# module "GitHub_module_commit" {
#   source = "git::https://github.com/simple-tech-with-tarun/terraform-module-source-lab.git?ref=48a0d48cd7a7d5c2bbddaab8c8457e2cd51c00ca"
# }

module "GitHub_module" {
  source = "git::https://github.com/simple-tech-with-tarun/terraform-module-source-lab.git"
}

module "GitHub_module_commit" {
  source = "git::https://github.com/simple-tech-with-tarun/terraform-module-source-lab.git?ref=48a0d48cd7a7d5c2bbddaab8c8457e2cd51c00ca"
}
