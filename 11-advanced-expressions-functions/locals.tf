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
  high_availability = false
  replica_count     = local.environment == "prod" && local.high_availability ? 3 : 1

  is_critical_environment = local.environment == "prod" || local.environment == "stage"

  is_non_production = !(local.environment == "prod")

  deployment_eligible = (local.environment == "prod" || local.environment == "stage") && local.high_availability

  vm_size      = local.environment == "prod" ? "Standard_D2s_v5" : "Standard_B2s"
  vm_size_prod = local.environment == "prod" && local.high_availability ? "Standard_D2s_v5" : "Standard_B2s"

  vm_sizes = {
    dev   = "Standard_B2s"
    stage = "Standard_D2s_v5"
    prod  = "Standard_D4s_v5"
  }

  selected_vm_size = lookup(local.vm_sizes, local.environment, "Standard_D4s_v6")

  environment_summary = local.environment == "prod" ? "Production environment" : "Non-production environment"

  deployment_status = local.environment == "prod" && local.high_availability ? "Ready for deployment" : "Not ready for deployment"

  requires_high_availability = local.environment == "prod" || local.environment == "stage"

  production_environment_regions = {
    for key, value in local.environment_regions :
    key => value
    if key == "prod"

  }
  environment_regions_uppercase = {
    for key, value in local.environment_regions :
    upper(key) => upper(value)
  }

  environment_index = {
    for index, value in local.environments :
    upper(value) => index
  }

  indian_environment_regions = {
    for key, value in local.environment_regions :
    key => value
    if strcontains(value, "india")
  }

  environment_applications = {
    dev   = ["frontend", "backend"]
    stage = ["frontend", "backend", "database"]
    prod  = ["frontend", "backend", "database", "monitoring"]
  }

  flat_applications = flatten([
    for each, value in local.environment_applications :
    value
  ])

  unique_applications = distinct(flatten([
    for key, value in local.environment_applications : value
    ]
  ))

  application_count_by_environment = {
    for key, index in local.environment_applications :
    key => length(index)
  }

  large_environments = {
    for key, value in local.environment_applications :
    key => value
    if length(value) > 2
  }
  environment_summary_map = {
    for key, value in local.environment_applications :
    key => "${key} has ${length(value)} applications"
  }

  environment_summary_map2 = {
    for key, value in local.environment_applications :
    key => format("%s has %d applications", key, length(value))
  }

  environment_application_map = {
    for key, value in local.environment_applications :
    key => format("%s: %s", key, join(", ", value))
  }

  environment_application_summary1 = join("| ", [for key, value in local.environment_application_map : value])

  environment_application_summary2 = join("| ", [for key, value in {
    for key, value in local.environment_applications :
    key => format("%s: %s", key, join(", ", value))
  } : value])

  sorted_environments          = sort(local.environments)
  reversed_environments        = reverse(local.environments)
  reversed_sorted_environments = reverse(sort(local.environments))

  applications = [
    "frontend",
    "backend",
    "frontend",
    "database",
    "backend"
  ]

  unique_applications_sorted = distinct(sort(local.applications))
  applications_set           = toset(local.applications)

  environment_names = ["dev", "stage", "prod"]

  environment_region = [
    "centralindia",
    "westindia",
    "eastus"
  ]
  names_regions = zipmap(local.environment_names, local.environment_region)

  frontend_services = toset(["frontend", "api", "auth"])

  backend_services = toset(["api", "database", "auth"])
  all_services     = setunion(local.frontend_services, local.backend_services)

  set_a        = toset(["frontend", "api"])
  set_b        = toset(["api", "database"])
  set_c        = toset(["database", "monitoring", "api"])
  number_list  = ["1", "3", "2", "1", "11", "15", "16", "11"]
  port         = [10, 20, 40, 8080, 80, 443]
  intersection = setintersection(local.set_a, local.set_b, local.set_c)
  subtract     = setsubtract(local.set_a, local.set_b)

  application_set  = toset(local.applications)
  application_list = tolist(local.application_set)
  converted_map    = tomap(local.environment_regions)

  number        = [for value in local.number_list : tonumber(value)]
  small_number  = min(local.number...)
  large_number  = max(local.number...)
  port_string   = [for value in local.port : tostring(value)]
  number_string = [for value in local.port_string : tonumber(value)]

  sample_text = "Terraform is fun in 2026 version 2"

  extracted_text = regexall("[A-Za-z]+|[0-9]+", local.sample_text)
}
