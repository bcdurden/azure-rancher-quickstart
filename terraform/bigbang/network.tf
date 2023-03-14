resource "azurerm_public_ip" "rancher_server_pip" {
  name                = "bigbang-dsop-pub-ip"
  location            = data.azurerm_resource_group.rancher_demo.location
  resource_group_name = data.azurerm_resource_group.rancher_demo.name
  allocation_method   = "Static"

  tags = {
    demo_type = "bigbang"
  }
}
resource "azurerm_network_interface" "rancher_server_interface" {
  name                = "bigbang-dsop-interface"
  location            = data.azurerm_resource_group.rancher_demo.location
  resource_group_name = data.azurerm_resource_group.rancher_demo.name

  ip_configuration {
    name                          = "bigbang_dsop_ip_config"
    subnet_id                     = data.azurerm_subnet.rancher_bigbang.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rancher_server_pip.id
  }

  tags = {
    demo_type = "bigbang"
  }
}
resource "azurerm_network_interface" "rancher_worker_interfaces" {
  count = var.worker_count

  name                = "bigbang-dsop-worker-interface-${count.index}"
  location            = data.azurerm_resource_group.rancher_demo.location
  resource_group_name = data.azurerm_resource_group.rancher_demo.name

  ip_configuration {
    name                          = "bigbang_dsop_worker_ip_config-${count.index}"
    subnet_id                     = data.azurerm_subnet.rancher_bigbang.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    demo_type = "bigbang"
  }
}