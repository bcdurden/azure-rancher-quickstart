data "cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    filename = "cloud-config.yaml"
    content_type = "text/cloud-config"
    content = <<EOT
      #cloud-config
      package_update: true
      write_files:
      - path: /etc/rancher/rke2/config.yaml
        owner: root
        content: |
          token: ${var.cluster_token}
          tls-san:
          - ${var.rancher_server_dns}
          - ${azurerm_public_ip.rancher_lb_ip.ip_address}
      runcmd:
      - curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION=${var.rke2_version} sh -
      - systemctl enable rke2-server.service
      - systemctl start rke2-server.service
      ssh_authorized_keys: 
      - ${tls_private_key.global_key.public_key_openssh}
    EOT
  }
}
data "cloudinit_config" "worker_config" {
  gzip          = true
  base64_encode = true

  part {
    filename = "cloud-config.yaml"
    content_type = "text/cloud-config"
    content = <<EOT
      #cloud-config
      package_update: true
      write_files:
      - path: /etc/rancher/rke2/config.yaml
        owner: root
        content: |
          token: ${var.cluster_token}
          server: https://${azurerm_linux_virtual_machine.rancher_server.private_ip_address}:9345
          tls-san:
          - ${var.rancher_server_dns}
          - ${azurerm_public_ip.rancher_server_pip.ip_address}
          - ${azurerm_public_ip.rancher_lb_ip.ip_address}
      runcmd:
      - curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" INSTALL_RKE2_VERSION=${var.rke2_version} sh -
      - systemctl enable rke2-agent.service
      - systemctl start rke2-agent.service
      ssh_authorized_keys: 
      - ${tls_private_key.global_key.public_key_openssh}
    EOT
  }
}