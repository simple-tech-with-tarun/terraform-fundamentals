terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

module "file1" {
  source    = "./modules/file"
  file_name = "custom-module1.txt"
  content   = "custom-module1-txt"
}

output "file_name1" {
  value = module.file1.filename
}

output "content1" {
  value = module.file1.content
}


module "file2" {
  source    = "./modules/file"
  file_name = "custom-module2.txt"
  content   = "custom-module2-txt"
}

output "file_name2" {
  value = module.file2.filename
}

output "content2" {
  value = module.file2.content
}
