resource "azurerm_storage_account" "statestorage" {
  name                     = "rgsazurestore"
  resource_group_name      = azurerm_resource_group.rancher_demo.name
  location                 = azurerm_resource_group.rancher_demo.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    demo_type = "bigbang"
  }
}
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.statestorage.name
  container_access_type = "private"
}