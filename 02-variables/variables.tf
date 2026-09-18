variable "message" {
  type    = string
  default = "Hello from Terraform Variables!"
}

variable "file_name" {
  type    = string
  default = "hello.txt"
}

variable "file_names" {
  type    = list(string)
  default = ["hello.txt", "world.txt"]
}

variable "tags" {
  type = map(string)

  default = {
    environment = "dev"
    application = "web"
    owner       = "terraform"
  }
}
