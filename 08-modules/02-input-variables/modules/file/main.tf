terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "example" {
  filename = "${var.m_environment_key}.txt"
  content  = "${var.m_environment.name} environment in ${var.m_environment.region}"
}
