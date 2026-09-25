

variable "environments" {
  type = map(object({
    name   = string
    region = string
  }))
}

