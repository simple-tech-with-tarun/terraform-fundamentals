terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}
locals {
  enabled_environments = {
    for name, config in var.environments :
    name => config
    if config.enabled
  }
}

module "environment" {
  source   = "./modules/environment"
  for_each = local.enabled_environments

  m_environment_name = each.key
  m_region           = each.value.region
}

module "summary" {
  source   = "./modules/summary"
  for_each = local.enabled_environments

  m_environment_name = each.key
  m_environment_file = module.environment[each.key].filename
}