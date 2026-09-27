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

module "final" {
  source = "./modules/final"

  m_consumer_filename = module.consumer.filename
}