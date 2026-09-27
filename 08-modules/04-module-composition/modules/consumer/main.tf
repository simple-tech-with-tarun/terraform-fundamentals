terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "consumer" {
  filename = "consumer.txt"
  content  = "Source file is: ${var.m_source_filename}"
}