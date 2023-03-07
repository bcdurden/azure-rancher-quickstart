resource "azurerm_public_ip" "rancher_server_pip" {
  name                = "rancher-server-pub-ip"
  location            = data.azurerm_resource_group.rancher_demo.location
  resource_group_name = data.azurerm_resource_group.rancher_demo.name
  allocation_method   = "Static"

  tags = {
    demo_type = "bigbang"
  }
}
resource "azurerm_network_interface" "rancher_server_interface" {
  name                = "rancher-server-interface"
  location            = data.azurerm_resource_group.rancher_demo.location
  resource_group_name = data.azurerm_resource_group.rancher_demo.name

  ip_configuration {
    name                          = "rancher_server_ip_config"
    subnet_id                     = data.azurerm_subnet.rancher_bigbang.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rancher_server_pip.id
  }

  tags = {
    demo_type = "bigbang"
  }
}