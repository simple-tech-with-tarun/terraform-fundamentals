variable "m_environment" {
  type = object({
    name   = string
    region = optional(string, "Central India")
  })
}
