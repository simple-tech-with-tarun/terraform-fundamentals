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
output "selected_vm_size" {
  value = local.selected_vm_size
}

output "environment_summary" {
  value = local.environment_summary
}

output "deployment_status" {
  value = local.deployment_status
}
output "requires_high_availability" {
  value = local.requires_high_availability
}
output "is_non_production" {
  value = local.is_non_production
}

output "production_environment_regions" {
  value = local.production_environment_regions
}
output "environment_regions_uppercase" {
  value = local.environment_regions_uppercase
}
output "environment_index" {
  value = local.environment_index
}
output "indian_environment_regions" {
  value = local.indian_environment_regions
}
output "flat_applications" {
  value = local.flat_applications
}
output "unique_applications" {
  value = local.unique_applications
}
output "application_count_by_environment" {
  value = local.application_count_by_environment
}
output "large_environments" {
  value = local.large_environments
}
output "environment_summary_map" {
  value = local.environment_summary_map
}
output "environment_summary_map2" {
  value = local.environment_summary_map2
}
output "environment_application_summary1" {
  value = local.environment_application_summary1
}
output "environment_application_summary2" {
  value = local.environment_application_summary2
}
output "sorted_environments" {
  value = local.sorted_environments
}
output "reversed_environments" {
  value = local.reversed_environments
}
output "reversed_sorted_environments" {
  value = local.reversed_sorted_environments
}
output "unique_applications_sorted" {
  value = local.unique_applications_sorted
}
output "applications_set" {
  value = local.applications_set
}
output "all_services" {
  value = local.all_services
}
output "intersection" {
  value = local.intersection
}
output "subtract" {
  value = local.subtract
}
