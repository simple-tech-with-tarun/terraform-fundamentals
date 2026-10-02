locals {
  subnets = {
    frontend = {
      name = var.frontend_subnet_name
      cidr = var.frontend_subnet_cidr
    }

    backend = {
      name = var.backend_subnet_name
      cidr = var.backend_subnet_cidr
    }

    database = {
      name = var.database_subnet_name
      cidr = var.database_subnet_cidr
    }
  }

  nsgs = {
    frontend = {
      name = "${var.vnet_name}-frontend-nsg"

      rules = {
        http = {
          name                   = "Allow-HTTP"
          priority               = 100
          destination_port_range = "80"
        }

        https = {
          name                   = "Allow-HTTPS"
          priority               = 110
          destination_port_range = "443"
        }
      }
    }

    backend = {
      name = "${var.vnet_name}-backend-nsg"

      rules = {
        application = {
          name                   = "Allow-Application"
          priority               = 100
          destination_port_range = "8080"
          source_address_prefix  = var.frontend_subnet_cidr
        }
      }
    }

    database = {
      name = "${var.vnet_name}-database-nsg"

      rules = {
        postgresql = {
          name                   = "Allow-PostgreSQL"
          priority               = 100
          destination_port_range = "5432"
          source_address_prefix  = var.backend_subnet_cidr
        }
      }
    }
  }
}
