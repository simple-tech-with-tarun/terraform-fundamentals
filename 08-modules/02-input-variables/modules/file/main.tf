terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "example" {
  for_each = local.environment_resource_groups_map

  filename = "${each.key}.txt"

  content = <<-EOT
    Environment: ${each.value.environment}
    Location: ${each.value.location}
    Resource Group: ${each.value.name}
  EOT
}

locals {
  environment_resource_groups = flatten([
    for env_key, env in var.m_environment : [
      for rg_key, rg in env.resource_groups : {
        key         = "${env_key}-${rg_key}"
        environment = env_key
        location    = env.location
        name        = rg.name
      }
    ]
  ])

  environment_resource_groups_map = {
    for rg in local.environment_resource_groups :
    rg.key => rg
  }
}

output "environment_resource_groups" {
  value = local.environment_resource_groups_map
}
