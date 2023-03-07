output "rancher_node_ip" {
  value = azurerm_linux_virtual_machine.rancher_server.public_ip_address
}

output "rancher_lb_ip" {
  value = azurerm_public_ip.rancher_lb_ip.ip_address
}
output "rancher_dns" {
  value = var.rancher_server_dns
}