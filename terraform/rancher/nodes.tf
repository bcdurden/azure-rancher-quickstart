locals {
  computer_name_prefix = substr(var.prefix, 0, 11)
}

resource "azurerm_linux_virtual_machine" "rancher_server" {
  name                  = "${var.prefix}-server-0"
  computer_name         = "${local.computer_name_prefix}-rs" // ensure computer_name meets 15 character limit
  location              = data.azurerm_resource_group.rancher_demo.location
  resource_group_name   = data.azurerm_resource_group.rancher_demo.name
  network_interface_ids = [azurerm_network_interface.rancher_server_interface.id]
  size                  = var.instance_type
  admin_username        = local.node_username

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  admin_ssh_key {
    username   = local.node_username
    public_key = tls_private_key.global_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  tags = {
    demo_type = "bigbang"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip_address
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }

  custom_data = data.cloudinit_config.config.rendered

}