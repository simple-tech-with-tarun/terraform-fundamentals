output "environment_names" {
  value = keys(local.environment_regions)
}

output "configured_regions" {
  value = values(local.environment_regions)
}
output "production_region" {
  value = lookup(local.environment_regions, "prod", "one")
}
output "test_region" {
  value = lookup(local.environment_regions, "test", "centralus")
}
output "production_resource_tags" {
  value = local.production_resource_tags
}
output "development_resource_tags" {
  value = local.development_resource_tags
}

output "allows_https" {
  value = contains(local.unique_production_ports, 443)
}

output "allowed_port_count" {
  value = length(local.unique_production_ports)
}

output "uppercase_environments" {
  value = local.uppercase_environments
}

output "production_environments" {
  value = local.production_environments
}

output "production_environment_names" {
  value = local.production_environment_names
}
output "staging_environment_names" {
  value = local.staging_environment_names
}
output "replica_count" {
  value = local.replica_count
}
output "is_critical_environment" {
  value = local.is_critical_environment
}
