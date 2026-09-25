variable "m_environment" {
  type = object({
    name   = string
    region = string
  })
}
variable "m_environment_key" {
  type = string
}
