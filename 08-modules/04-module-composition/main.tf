terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

variable "environments" {
  type = set(string)

  default = ["dev", "prod"]
}

module "source" {
  source   = "./modules/source"
  for_each = var.environments

  m_environment = each.key
}

module "consumer" {
  source   = "./modules/consumer"
  for_each = var.environments

  m_environment      = each.key
  m_source_filename  = module.source[each.key].filename
}