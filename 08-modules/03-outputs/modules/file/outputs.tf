output "filename" {
  value = local_file.example.filename
}

output "content" {
  value = local_file.example.content
}

output "message" {
  value = var.m_message
}
output "message_summary" {
  value = "Child module received: ${var.m_message}"
}
