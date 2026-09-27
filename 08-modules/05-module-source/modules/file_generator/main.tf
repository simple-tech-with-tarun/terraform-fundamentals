terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "example" {
  filename = "module-source.txt"
  content  = "Module loaded from a local source."
}