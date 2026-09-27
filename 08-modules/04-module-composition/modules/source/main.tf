terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "source" {
  filename = "${var.m_environment}-source.txt"
  content  = "Created by the source module for ${var.m_environment}."
}
