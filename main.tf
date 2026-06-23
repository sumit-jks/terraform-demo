resource "azurerm_resource_group" "tutorial" {
  name     = "tutorial-rg"
  location = "West Europe"
}

resources "azurerm_virtual_network" "tutorial" {
  name                = "tutorial-vnet"
  address_space       = ["10.0.0.0/16"]
}
