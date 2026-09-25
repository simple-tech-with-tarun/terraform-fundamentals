terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

module "file" {
  source   = "./modules/file"
  for_each = var.environments

  m_environment_key = each.key
  m_environment     = each.value
}
