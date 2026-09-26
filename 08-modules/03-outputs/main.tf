terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

module "file" {
  source    = "./modules/file"
  m_message = "Hello from the root module."
}

output "file_name_root" {
  value = module.file.filename
}

output "file_content_root" {
  value = module.file.content
}
output "root_message" {
  value = module.file.message
}
output "root_summary" {
  value = module.file.message_summary
}
output "root_combined" {
  value = "${module.file.filename} | ${module.file.content} | ${module.file.message}"
}
