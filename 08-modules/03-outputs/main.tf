terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

module "file" {
  source    = "./modules/file"
  for_each  = var.environments
  m_message = "Hello from the root module."
}


output "environment_messages" {
  value = {
    for key, module_instance in module.file :
    key => module_instance.message
  }
}

output "message_dev" {
  value = module.file["dev"].message
}
output "message_prod" {
  value = module.file["prod"].message
}
