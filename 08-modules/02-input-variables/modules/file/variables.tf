variable "m_environment" {
  type = map(object({
    location = string

    resource_groups = map(object({
      name = string
    }))
  }))
}
