terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "source" {
  filename = "source.txt"
  content  = "Created by the source module."
}
