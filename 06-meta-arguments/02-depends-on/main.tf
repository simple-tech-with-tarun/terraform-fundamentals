terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "first" {
  filename = "first.txt"
  content  = "First resource - changed"
}

resource "local_file" "second" {
  depends_on = [local_file.first]
  filename   = "second.txt"
  content    = "Second resource"
}
