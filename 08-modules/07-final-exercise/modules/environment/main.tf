resource "local_file" "environment" {
  filename = "${var.m_environment_name}-environment.txt"

  content = <<-EOT
    Environment: ${var.m_environment_name}
    Region: ${var.m_region}
  EOT
}