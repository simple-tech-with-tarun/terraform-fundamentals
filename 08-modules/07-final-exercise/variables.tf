variable "environments" {
  type = map(object({
    region  = string
    enabled = bool
  }))
}