terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

module "file" {
  source         = "./modules/file"
  for_each       = var.environments
  m_environments = each.value
}
