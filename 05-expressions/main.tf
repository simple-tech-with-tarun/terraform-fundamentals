terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "environment" {
  filename = "environment.txt"

  content = var.environment == "prod" ? "Production environment" : "Non-production environment"
}



resource "local_file" "environment_file" {
  for_each = {
    dev   = "Development"
    prod  = "Production"
    stage = "Staging"
  }
  filename = "${each.key}.txt"
  content  = "This is ${each.value} environment"
}

resource "local_file" "count_environment"{
count = 1
filename = "count-${count.index}.txt"
content= "Environment number ${count.index}"
}