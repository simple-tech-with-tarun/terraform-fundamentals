output "environment_files" {
  value = {
    for name, environment in module.environment :
    name => environment.filename
  }
}
output "summary_files" {
  value = {
    for name, summary in module.summary :
    name => summary.filename
  }
}
