# terraform-demo

Azure Infrastructure with Terraform (Bastion & Networking)
This repository contains basic Terraform configurations to provision core networking components, a Network Security Group (NSG), and an Azure Bastion Host for secure VM management.

Architecture Overview
The configuration deploys the following resources within a single Resource Group:

Virtual Network (VNet): A core network space split into two subnets.

AzureBastionSubnet: Dedicated exclusively to the Azure Bastion Host.

Subnet3: A general-purpose backend subnet.

Network Security Group (NSG): Associated with Subnet3 to control inbound/outbound traffic.

Azure Bastion: Deployed with a dedicated Public IP to provide secure, seamless RDP/SSH connectivity without exposing internal VMs to the public internet.

NOTE: i have skipped the VMs for now to keep this light. please go ahead & use it to practice basic terraform codes. 

# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "demo-resources"
  location = "East US"
}

# 2. Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "demo-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 3. Bastion Subnet (Must be named exactly 'AzureBastionSubnet')
resource "azurerm_subnet" "subnet_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/26"] # Minimum /26 required for Bastion
}

# 4. Backend Subnet (Subnet3)
resource "azurerm_subnet" "subnet3" {
  name                 = "demo-subnet3"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# 5. Network Security Group
resource "azurerm_network_security_group" "nsg3" {
  name                = "demo-subnet3-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-Internal"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "*"
  }
}

# 6. Associate NSG to Subnet3
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet3.id
  network_security_group_id = azurerm_network_security_group.nsg3.id
}

# 7. Public IP for Azure Bastion
resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "demo-bastion-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard" # Bastion requires a Standard SKU Public IP
}

# 8. Azure Bastion Host
resource "azurerm_bastion_host" "bastion" {
  name                = "demo-bastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet_bastion.id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
}
