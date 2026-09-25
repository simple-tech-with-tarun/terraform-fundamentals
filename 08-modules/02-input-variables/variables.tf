variable "environments" {
  type = map(object({
    location = string

    resource_groups = map(object({
      name = string
    }))
  }))

  default = {
    dev = {
      location = "Central India"

      resource_groups = {
        app = {
          name = "dev-app-rg"
        }

        data = {
          name = "dev-data-rg"
        }
      }
    }

    prod = {
      location = "East US"

      resource_groups = {
        app = {
          name = "prod-app-rg"
        }

        data = {
          name = "prod-data-rg"
        }
      }
    }
    prod2 = {
      location = "East UK"

      resource_groups = {
        "1app2" = {
          name = "prod2-app-rg"
        }

        "1data2" = {
          name = "prod2-data-rg"
        }
      }
    }
  }
}

# output "dev_location" {
#   value = var.environments["dev"].location
# }

# output "dev_app_rg_name" {
#   value = var.environments["dev"].resource_groups["app"].name
# }

# output "prod_data_rg_name" {
#   value = var.environments["prod"].resource_groups["data"].name
# }
