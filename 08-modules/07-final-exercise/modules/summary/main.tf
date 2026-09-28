resource "local_file" "summary" {
  filename = "${var.m_environment_name}-summary.txt"

  content = <<-EOT
    Environment: ${var.m_environment_name}
    Environment file: ${var.m_environment_file}
  EOT
}