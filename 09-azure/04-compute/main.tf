terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "lab" {
  name = "terraform-azure-lab-rg"
}

data "azurerm_subnet" "frontend" {
  name                 = "frontend-subnet"
  virtual_network_name = "terraform-azure-vnet"
  resource_group_name  = data.azurerm_resource_group.lab.name
}

resource "azurerm_network_interface" "frontend" {
  name                = "frontend-nic"
  location            = data.azurerm_resource_group.lab.location
  resource_group_name = data.azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "frontend-ip-config"
    subnet_id                     = data.azurerm_subnet.frontend.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    AutoDelete = "yes"
    Owner      = "tarun"
  }
}

data "azurerm_subnet" "backend" {
  name                 = "backend-subnet"
  virtual_network_name = "terraform-azure-vnet"
  resource_group_name  = data.azurerm_resource_group.lab.name
}

resource "azurerm_network_interface" "backend" {
  name                = "backend-nic"
  location            = data.azurerm_resource_group.lab.location
  resource_group_name = data.azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "backend-ip-config"
    subnet_id                     = data.azurerm_subnet.backend.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    AutoDelete = "yes"
    Owner      = "tarun"
  }
}
resource "azurerm_linux_virtual_machine" "frontend" {
  name                = "frontend-vm"
  resource_group_name = data.azurerm_resource_group.lab.name
  location            = data.azurerm_resource_group.lab.location
  size                = "Standard_D2s_v5"

  admin_username = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.frontend.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = {
    AutoDelete = "yes"
    Owner      = "tarun"
  }
}

resource "azurerm_linux_virtual_machine" "backend" {
  name                = "backend-vm"
  resource_group_name = data.azurerm_resource_group.lab.name
  location            = data.azurerm_resource_group.lab.location
  size                = "Standard_D2s_v5"

  admin_username = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.backend.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = {
    AutoDelete = "yes"
    Owner      = "tarun"
  }
}
