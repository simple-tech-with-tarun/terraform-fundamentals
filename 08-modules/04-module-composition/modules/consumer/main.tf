terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "consumer" {
   filename = "${var.m_environment}-consumer.txt"
  content  = "Source file is: ${var.m_source_filename}"
}