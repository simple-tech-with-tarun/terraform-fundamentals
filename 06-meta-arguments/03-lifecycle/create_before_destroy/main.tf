terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "example" {
  filename = "lifecycle-v2.txt"
  content  = "Version 1"

  lifecycle {
    create_before_destroy = true
  }
}
