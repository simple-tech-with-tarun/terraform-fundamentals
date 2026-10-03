locals {
  admin_username = "azureadmin"

  virtual_machines = {
    frontend = {
      name      = "terraform-final-project-frontend-vm"
      subnet_id = var.frontend_subnet_id
    }

    backend = {
      name      = "terraform-final-project-backend-vm"
      subnet_id = var.backend_subnet_id
    }
  }
}