terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "example" {
  for_each = var.m_environment
  filename = "${each.key}.txt"
  content = <<-EOT
    Environment: ${each.key}
    Location: ${each.value.location}

    Resource Groups:
    ${join("\n", [
  for rg_key, rg in each.value.resource_groups :
  "  ${rg_key}: ${rg.name}"
])}
  EOT
}
