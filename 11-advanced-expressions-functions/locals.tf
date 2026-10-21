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

  environments           = ["dev", "stage", "prod"]
  uppercase_environments = [for item in local.environments : upper(item)]

  production_environments = [for item in local.environments : item if item == "prod"]

  production_environment_names = [for item in local.environments : upper(item) if item == "prod"]
  staging_environment_names    = upper(one([for item in local.environments : item if item == "stage"]))

  environment       = "prod"
  high_availability = true
  replica_count     = local.environment == "prod" && local.high_availability ? 3 : 1

  is_critical_environment = local.environment == "prod" || local.environment == "stage"

  is_non_production = !(local.environment == "prod")

  deployment_eligible = (local.environment == "prod" || local.environment == "stage") && local.high_availability

  vm_size = local.environment == "prod" ?"Standard_D2s_v5" : "Standard_B2s"
  vm_size_prod = local.environment == "prod" && local.high_availability ?"Standard_D2s_v5" : "Standard_B2s"
}
