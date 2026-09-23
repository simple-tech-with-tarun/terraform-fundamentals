terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "inspection" {
  filename = "inspection.txt"
  content  = "Terraform State Inspection v3"
}
output "inspection_filename" {
  value = local_file.inspection.filename
}

output "inspection_content" {
  value = local_file.inspection.content
}
