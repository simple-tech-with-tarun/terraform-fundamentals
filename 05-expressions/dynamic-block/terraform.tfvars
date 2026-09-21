rg = {
  rg1 = {
    name     = "terraform-dynamic-block-rg"
    location = "central India"
    tags = {
      owner = "tarun"
    }
  }
}

nsg = {
  nsg1 = {
    name     = "terraform-dynamic-block-nsg1"
    location = "central India"
    rg_name  = "terraform-dynamic-block-rg"

    rule = {
      http = {
        name                   = "allow-http"
        priority               = 100
        destination_port_range = "80"
      }

      https = {
        name                   = "allow-https"
        priority               = 110
        destination_port_range = "443"
      }
      ssh = {
        name                   = "allow-ssh"
        priority               = 120
        destination_port_range = "22"
      }
    }
  }
  nsg2 = {
    name     = "terraform-dynamic-block-nsg2"
    location = "central India"
    rg_name  = "terraform-dynamic-block-rg"

    rule = {
      ssh = {
        name                   = "allow-ssh"
        priority               = 220
        destination_port_range = "22"
      }
      http = {
        name                   = "allow-http"
        priority               = 110
        destination_port_range = "80"
      }
    }
  }
}
