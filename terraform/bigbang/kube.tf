resource "ssh_resource" "retrieve_config" {
  host = azurerm_public_ip.rancher_server_pip.ip_address
  depends_on = [
    azurerm_linux_virtual_machine.rancher_server
  ]
  commands = [
    "sudo sed \"s/127.0.0.1/${azurerm_public_ip.rancher_lb_ip.ip_address}/g\" /etc/rancher/rke2/rke2.yaml"
  ]
  user        = local.node_username
  private_key = tls_private_key.global_key.private_key_pem
}

resource "local_file" "kube_config_server_yaml" {
  filename = format("%s/%s", path.root, "bigbang.yaml")
  content  = ssh_resource.retrieve_config.result
}
