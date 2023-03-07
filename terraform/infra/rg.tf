# Resource group containing all resources
resource "azurerm_resource_group" "rancher_demo" {
  name     = "rancher-bigbang"
  location = var.azure_location

  tags = {
    demo_type = "bigbang"
  }
}