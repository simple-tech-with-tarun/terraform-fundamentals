terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "example" {
  filename = "${var.m_environments.name}.txt"
  content  = "${var.m_environments.name} environment in ${var.m_environments.region}"
}
