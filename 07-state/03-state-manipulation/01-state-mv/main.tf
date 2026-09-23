terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "renamed" {
  filename = "state-mv-example.txt"
  content  = "State move experiment"
}