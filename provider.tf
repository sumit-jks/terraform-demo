terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.67.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "tfstatestorage2406"
    container_name       = "tfstate"
    key                  = "project1.tfstate"
  }
}

provider "azurerm" {
  features {}
}
