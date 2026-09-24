terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

module "file" {
  source = "./modules/file"

  #   m_filename = var.environment_file
  m_content = var.environment_content
}
