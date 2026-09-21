terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "protected" {
  filename = "protected-v2.txt"
  content  = "This file is protected - version 2."

  lifecycle {
    prevent_destroy = true
  }
}
