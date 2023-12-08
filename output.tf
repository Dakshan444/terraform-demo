output "private_ip" {
    description = "IP Address of Virtual Machine"
    value = azurerm_network_interface.nic.private_ip_address
}