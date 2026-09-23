terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "example" {
  filename = "state-example.txt"
  content  = "Terraform State Lab"
}