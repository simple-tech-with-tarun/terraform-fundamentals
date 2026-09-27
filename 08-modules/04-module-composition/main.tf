terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

module "source" {
  source = "./modules/source"
}

module "consumer" {
  source = "./modules/consumer"

  m_source_filename = module.source.filename
}