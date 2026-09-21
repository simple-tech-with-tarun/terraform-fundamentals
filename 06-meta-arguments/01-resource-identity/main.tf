terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

variable "environments" {
  type    = list(string)
  default = ["prod", "dev"]
}

resource "local_file" "count_example" {
  count = length(var.environments)

  filename = "count-${count.index}.txt"
  content  = "Environment: ${var.environments[count.index]}"
}

resource "local_file" "foreach_example" {
  for_each = toset(var.environments)

  filename = "foreach-${each.key}.txt"
  content  = "Environment: ${each.key}"
}
