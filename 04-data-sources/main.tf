terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "source" {
  filename = "source.txt"
  content  = "This file was created by Terraform."
}

data "local_file" "existing" {
  filename = local_file.source.filename
}
