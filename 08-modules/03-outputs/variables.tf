variable "environments" {
  type = map(string)

  default = {
    dev  = "Development"
    prod = "Production"
  }
}