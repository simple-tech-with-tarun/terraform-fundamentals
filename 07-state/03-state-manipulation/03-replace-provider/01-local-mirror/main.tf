terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "example" {
  filename = "replace-provider-example.txt"
  content  = "Provider replacement experiment"
}
