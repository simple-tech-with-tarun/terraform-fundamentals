terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "hello" {
  filename = var.file_name
  content  = "Files configured: ${join("? ", var.file_names)}!\n ${var.message}"
}
