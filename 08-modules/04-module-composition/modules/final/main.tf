terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "final" {
  filename = "final.txt"
  content  = "Consumer file is: ${var.m_consumer_filename}"
}