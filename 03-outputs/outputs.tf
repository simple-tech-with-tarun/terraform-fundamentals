output "file_name" {
  value = local_file.hello.filename
}

output "content" {
  value = local_file.hello.content
}

output "content_md5" {
  value = local_file.hello.content_md5
}

output "file_names" {
  value = var.file_names
}

output "configured_message" {
  value = var.message
}

output "demo_secret" {
  value     = "this-is-a-demo-secret"
  sensitive = true
}

output "file_summary" {
  value = "${local_file.hello.filename} contains the configured message."
}
