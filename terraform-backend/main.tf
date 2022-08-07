terraform {
  required_providers {
    azurerm = {
      version = "3.16.0"
    }
  }

}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tfbackend" {
  name     = "rg-tfstate-sandbox"
  location = "UK South"
}

resource "random_string" "tfbackend_storage_account_name" {
  length = 13

  numeric = true
  lower   = true

  special = false
  upper   = false
}

resource "azurerm_storage_account" "tfbackend" {
  name                     = "sttfbackend${random_string.tfbackend_storage_account_name.result}"
  resource_group_name      = azurerm_resource_group.tfbackend.name
  location                 = azurerm_resource_group.tfbackend.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    Expires = "False"
  }
}

output "tfbackend_storage_account_name" {
  value = azurerm_storage_account.tfbackend.name
}