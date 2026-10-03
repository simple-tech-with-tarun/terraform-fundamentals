locals {
  common_tags = {
    Project    = var.project_name
    Environment = "lab"
    ManagedBy  = "Terraform"
  }

  vnet_name = "${var.project_name}-vnet"

  frontend_subnet_name = "${var.project_name}-frontend-subnet"
  backend_subnet_name  = "${var.project_name}-backend-subnet"
  database_subnet_name = "${var.project_name}-database-subnet"
}