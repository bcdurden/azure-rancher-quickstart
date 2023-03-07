output "rancher_node_ip" {
  value = azurerm_linux_virtual_machine.rancher_server.public_ip_address
}

