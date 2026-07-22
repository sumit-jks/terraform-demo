resource "azurerm_public_ip" "PIP" {
    for_each = var.pips
name = each.value.name
resource_group_name = each.value.resource_group_name
location = each.value.location
allocation_method = "Static"
sku = "Standard"
ip_version = "IPv4"

}