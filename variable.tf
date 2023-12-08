variable "location" {
    type = string
    description = "Azure location of terraform server environment"
    default = "westus2"

}

variable "vnet_address_space" { 
    type = list
    description = "Address space for Virtual Network"
    default = ["10.0.0.0/16"]
}

variable "snet_address_space" { 
    type = list
    description = "Address space for Virtual Network"
    default = ["10.0.0.0/24"]
}

variable "servername" {
    type = string
    description = "Server name of the virtual machine"
}

variable "admin_username" {
    type = string
    description = "Administrator username for server"
}

variable "admin_password" {
    type = string
    description = "Administrator password for server"
}


variable "managed_disk_type" { 
    type = map
    description = "Disk type Premium in Primary location Standard in DR location"

    default = {
        westus2 = "Premium_LRS"
        southcentralus = "Standard_LRS"
    }
}

variable "vm_size" {
    type = string
    description = "Size of VM"
    default = "Standard_B1s"
}

//add a variable name with os and give description, type. inside type add publisher,offer,sku,version and add sample values for it
variable "os" {
    default = {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2019-Datacenter"
        version = "latest"
    }
    description = "OS image to deploy"
    type = object({
        publisher = string
        offer = string
        sku = string
        version = string
  })
}      