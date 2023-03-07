# Azure virtual network space for quickstart resources
resource "azurerm_virtual_network" "rancher_bigbang" {
  name                = "${var.prefix}-network"
  address_space       = ["10.20.0.0/16"]
  location            = azurerm_resource_group.rancher_demo.location
  resource_group_name = azurerm_resource_group.rancher_demo.name

  tags = {
    demo_type = "bigbang"
  }
}

# Azure internal subnet for quickstart resources
resource "azurerm_subnet" "rancher_bigbang" {
  name                 = "rancher-bigbang"
  resource_group_name  = azurerm_resource_group.rancher_demo.name
  virtual_network_name = azurerm_virtual_network.rancher_bigbang.name
  address_prefixes     = ["10.20.0.0/24"]

  tags = {
    demo_type = "bigbang"
  }
}