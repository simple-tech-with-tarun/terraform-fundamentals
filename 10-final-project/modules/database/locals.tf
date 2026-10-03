locals {
  server_name   = "terraform-final-project-postgres"
  database_name = "appdb"
  dns_zone_name = "terraform-final-project.postgres.database.azure.com"

  administrator_login = var.administrator_login
}