terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "first" {
  filename = "first.txt"
  content  = "First resource"
}

resource "local_file" "second" {
  filename = "second.txt"
  content  = "Second resource"
}

resource "local_file" "third" {
  filename = "third.txt"
  content  = " ${local_file.second.content} third file"
}
