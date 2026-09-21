
output "environment_upper" {
  value = upper(var.environment)
}

output "is_production" {
  value = var.environment == "prod"
}

output "env" {
  value = var.environment == "prod" ? "Production" : "Development"
}

output "not_production" {
  value = var.environment != "prod"
}

output "environment_is_dev" {
  value = var.environment == "dev"
}

output "is_test_or_dev" {
  value = var.environment == "test" || var.environment == "dev"
}

output "is_prod_and_dev" {
  value = (var.environment == "prod" && var.environment == "dev") ? var.environment : "yes"
}

output "not_dev" {
  value = !(var.environment == "dev")
}

output "environment_options" {
  value = [for env in ["dev", "prod", "test"] : upper(env)]
}

output "non_prod_environments" {
  value = [for env in ["dev", "prod", "test"] : upper(env) if env != "prod"]
}

output "environment_map" {
  value = {
    for env in ["dev", "prod", "test"] :
    env => upper(env)
    if env != "prod"
  }
}

output "environment_settings_upper" {
  value = {
    for env, value in var.environment_settings :
    env => upper(value)
  }
}

output "nested_environments" {
  value = [
    ["dev", "prod"],
    ["test"]

  ]
}

output "flat_environments" {
  value = flatten([
    ["dev", "test"],
    ["prod"]
  ])
}


output "environtment_list" {
  value = ["dev", "prod", "test", "dev"]
}

output "environment_set" {
  value = toset(["dev", "prod", "test", "dev"])
}



output "environment_name" {
  value = local.environment_name
}

output "environment_type" {
  value = local.environment_type
}

output "environment_label" {
  value = local.environment_label
}
output "config_content" {
  value = local.config_content
}

output "config_upper" {
  value = local.config_upper
}


output "config_map" {
  value = local.config_map
}

output "config_map2" {
  value = local.config_map2
}
output "config_map3" {
  value = local.config_map3
}

output "try_value" {
  value = local.try_value
}

output "try_missing" {
  value = local.try_missing
}

output "can_value" {
  value = local.can_value
}

output "can_missing" {
  value = local.can_missing
}

output "application_name" {
  value = local.application_name
}

output "application_port" {
  value = local.application_port
}

output "application_protocol" {
  value = var.application_config.settings.protocol
}

output "application_timeout" {
  value = local.application_timeout
}

output "has_timeout" {
  value = local.has_timeout
}
