data "azurerm_public_ip" "pip" {
    for_each = var.nics
  name                = each.value.data_pip_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_subnet" "subnet" {
    for_each= var.nics
name = each.value.data_subnet_name
virtual_network_name = each.value.data_vnet_name
resource_group_name = each.value.resource_group_name
}

resource "azurerm_network_interface" "main" {
    for_each= var.nics
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = data.azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = data.azurerm_public_ip.pip[each.key].id
  }
}

resource "azurerm_network_security_group" "nsg" {
for_each = var.nics
name = "${each.key}-nsg"
location = each.value.location
resource_group_name = each.value.resource_group_name

security_rule {
name = "allow-ssh"
priority = 100
direction = "Inbound"
access = "Allow"
protocol = "Tcp"
source_port_range = "*"
destination_port_range = "22"
source_address_prefix = "*"
destination_address_prefix = "*"
}
}

resource "azurerm_subnet_network_security_group_association" "example" {
    for_each = var.nics
subnet_id = data.azurerm_subnet.subnet[each.key].id
network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}


resource "azurerm_virtual_machine" "main" {
    for_each = var.nics
  name                  = "${each.key}-vm"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  network_interface_ids = [azurerm_network_interface.main[each.key].id]
  vm_size               = "Standard_D2s_v3"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk${each.key}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}