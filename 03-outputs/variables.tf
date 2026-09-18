variable "message" {
  type    = string
  default = "Hello from Terraform Outputs!"
}

variable "file_name" {
  type    = string
  default = "hello.txt"
}

variable "file_names" {
  type    = list(string)
  default = ["hello.txt", "world.txt"]
}