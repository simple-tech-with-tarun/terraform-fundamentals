terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

module "file" {
  source = "./modules/file"
  count  = 2

  m_key     = "environment-${count.index}"
  m_message = "Environment ${count.index}"
}

output "environment_messages" {
  value = [
    for module_instance in module.file :
    module_instance.message
  ]
}

output "message_0" {
  value = module.file[0].message
}

output "message_1" {
  value = module.file[1].message
}
