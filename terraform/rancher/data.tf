data azurerm_virtual_network "demo_network" {
  name     = "${var.prefix}-network"
  resource_group_name  = data.azurerm_resource_group.rancher_demo.name
}
data "azurerm_subnet" "rancher_bigbang" {
  name                 = "rancher-bigbang"
  resource_group_name  = data.azurerm_resource_group.rancher_demo.name
  virtual_network_name = data.azurerm_virtual_network.demo_network.name
}
data "azurerm_resource_group" "rancher_demo" {
  name     = "rancher-bigbang"
}