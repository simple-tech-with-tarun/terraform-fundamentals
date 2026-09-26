terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "example" {
  filename = "module-output.txt"
  content  = "Created by the child module."
}

variable "m_message" {
  type = string
}