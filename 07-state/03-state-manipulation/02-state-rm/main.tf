terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "example" {
  filename = "state-rm-example.txt"
  content  = "State removal experiment"
}