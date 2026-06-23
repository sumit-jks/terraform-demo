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

resource "azurerm_subnet" "frontend" {
  name                 = "frontend-subnet"
  resource_group_name  = azurerm_resource_group.tutorial.name
  virtual_network_name = azurerm_virtual_network.tutorial.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "azureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.tutorial.name
  virtual_network_name = azurerm_virtual_network.tutorial.name
  address_prefixes     = ["10.0.2.0/24"]
}