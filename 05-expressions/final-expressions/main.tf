terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

variable "environments" {
  type = map(object({
    yes    = bool
    region = string
  }))
}

locals {
  enabled_environments = {
    for name, config in var.environments :
    name => config
    if config.yes
  }
}

resource "local_file" "environment" {
  for_each = local.enabled_environments

  filename = "${each.key}.txt"

  content = <<-multiline_marker
    Environment: ${upper(each.key)}
    Region: ${each.value.region}
  multiline_marker
}

output "enabled_environments" {
  value = keys(local.enabled_environments)
}
