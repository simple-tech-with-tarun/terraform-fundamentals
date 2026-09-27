terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "example" {
  filename = "${var.m_key}.txt"
  content  = "Created by the child module in ${var.m_message}."
}

variable "m_message" {
  type = string
}
variable "m_key" {
  type = string
}
