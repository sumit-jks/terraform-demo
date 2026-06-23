resource "azurerm_resource_group" "tutorial" {
  name     = "tutorial-rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "tutorial" {
  name                = "tutorial-vnet"
  location            = azurerm_resource_group.tutorial.location
  resource_group_name = azurerm_resource_group.tutorial.name
  address_space       = ["10.0.0.0/16"]
}
