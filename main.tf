#write a terraform azure code for creating a vm

#write a terraform azure code for creating a vm
# Terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.40.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "cal-3862-3fe"
    storage_account_name = "terraformstorages"
    container_name       = "tfstate"
    key                  = "terraformstorages.tfstate"
    subscription_id      = "3555dde6-72a3-47a0-8305-ad3715fb42c3"
    tenant_id            = "fd1fbf9f-991a-40b4-ae26-61dfc34421ef"
  }
}

#Azure provider
provider "azurerm" {
  features {}
}

#Get CloudAcademy Lab Resource Group
data "azurerm_resource_group" "rg" {
  name = "cal-3862-3fe"
}



#Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-dev-${var.location}-001"
    address_space       = var.vnet_address_space
    location            = var.location
    resource_group_name = data.azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "snet-dev-${var.location}-001 "
  resource_group_name  =  data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = var.snet_address_space
}


# Create network interface
resource "azurerm_network_interface" "nic" {
  name                      = "nic-01-${var.servername}-dev-001 "
  location                  = var.location
  resource_group_name       = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "niccfg-${var.servername}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = var.servername
  location              = var.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_B1s"

  storage_os_disk {
    name              = "stvm${var.servername}os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = lookup(var.managed_disk_type, var.location, "Standard_LRS")
  }

  storage_image_reference {
    publisher = var.os.publisher
    offer     = var.os.offer
    sku       = var.os.sku
    version   = var.os.version
  }

  os_profile {
    computer_name  = var.servername
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}




