resource "azurerm_resource_group" "rg" {
  name     = var.rg_name.name
  location = var.rg_name.location
}
