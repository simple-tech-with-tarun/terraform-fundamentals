variable "environment" {
  type    = string
  default = "dev"
}

variable "environment_settings" {
  type = map(string)
  default = {
    dev  = "Development"
    test = "Testing"
    prod = "Production"
  }
}

locals {
  environment_name = upper(var.environment)

  environment_type = var.environment == "prod" ? "Production" : "Non-Production"

  environment_label = "${local.environment_name} - ${local.environment_type}"
}

locals {
  config_content = file("${path.module}/config/config.txt")

  config_upper = upper(local.config_content)

  config_lines = split("\n", local.config_content)

  config_map = {
    for line in local.config_lines :
    split("=", line)[0] => split("=", line)[1]
  }

  config_map2 = {
    for line in local.config_lines :
    trimspace(split("=", line)[0]) => trimspace(split("=", line)[1])
  }

  config_lines2 = split("\r\n", local.config_content)

  config_map3 = {
    for line in local.config_lines2 :
    split("=", line)[0] => split("=", line)[1]
  }

try_value = try(split("=", "environment=production")[1], "unknown")

try_missing = try(split("=", "environment=production")[2], "unknown")

can_value = can(split("=", "environment=production")[1])

can_missing = can(split("=", "environment=production")[2])

}

variable "application_config" {
  type = object({
    name     = string
    settings = map(string)
  })

  default = {
    name = "web"

    settings = {
      port    = "8080"
      protocol = "https"
    }
  }
}
locals {
  application_name = var.application_config.name

  application_port = try(
    var.application_config.settings["port"],
    "not-configured"
  )

  application_timeout = try(
    var.application_config.settings["timeout"],
    "not-configured"
  )

  has_timeout = can(
    var.application_config.settings["timeout"]
  )
  
}