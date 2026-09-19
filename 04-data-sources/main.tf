terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "source" {
  filename = "source.txt"
  content  = "This file was created by Terraform."
}

data "local_file" "existing" {
  filename = local_file.source.filename
}

data "local_file" "existing-2" {
  filename = "./data-source.txt"
}
resource "local_file" "copy" {
  filename = "copy.txt"
  content  = data.local_file.existing-2.content
}

output "source" {
  value = local_file.source.content
}

output "s2" {
  value = data.local_file.existing-2.content
}

output "existing" {
  value = local_file.copy.content
}

output "external_file_name" {
  value = data.local_file.existing-2.filename
}
output "external_file_md5" {
  value = data.local_file.existing-2.content_md5
}
output "external_file_sha1" {
  value = data.local_file.existing-2.content_sha1
}
