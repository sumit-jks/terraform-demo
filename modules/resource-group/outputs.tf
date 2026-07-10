output "rg_name" {
  value = {
  name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
}
}
