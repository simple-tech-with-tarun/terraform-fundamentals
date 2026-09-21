terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "trigger" {
  filename = "trigger.txt"
  content  = "Version 2"
}

resource "local_file" "dependent" {
  filename = "dependent.txt"
  content  = "This resource has not changed."

  lifecycle {
    replace_triggered_by = [
      local_file.trigger
    ]
  }
}
