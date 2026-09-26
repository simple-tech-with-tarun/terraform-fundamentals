terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

module "file" {
  source        = "./modules/file"
  m_environment = var.environments

}

output "environment_resource_groups" {
  value = module.file.environment_resource_groups
}
