terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}
locals {
  environment_regions = {
    dev   = "centralindia"
    stage = "westindia"
    prod  = "eastus"
  }

  default_tags = {
    managed_by  = "terraform"
    project     = "expressions-lab"
    environment = "default"
  }
  production_tags = {
    environment = "prod"
    criticality = "high"
  }
  development_tags = {
    environment = "dev"
    criticality = "low"
  }
  production_resource_tags  = merge(local.default_tags, local.production_tags)
  development_resource_tags = merge(local.development_tags, local.default_tags)
  default_ports             = [80, 443]
  production_ports          = [443, 8080]


  all_production_ports    = concat(local.default_ports, local.production_ports)
  unique_production_ports = distinct(concat(local.default_ports, local.production_ports))

}
