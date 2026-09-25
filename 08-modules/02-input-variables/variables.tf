

variable "environment" {
  type = object({
    name   = string
    region = optional(string)
  })

  default = {
    name = "dev"

  }


  # validation {
  #   condition = (contains(["dev", "test", "prod"], lower(var.environment.name)) &&
  #   !contains(["central india", "east us"], lower(var.environment.region)))

  #   error_message = "environment.name must be dev, test, or prod, and environment.region must not be Central India or East US."
  # }

}

