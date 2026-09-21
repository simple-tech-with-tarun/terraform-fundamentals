terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "example" {
  filename = "changed-name.txt"
  content  = "Managed by Terraform"

  lifecycle {
    ignore_changes = [
      filename
    ]
  }
}
