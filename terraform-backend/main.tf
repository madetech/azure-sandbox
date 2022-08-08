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
  tags = {
    Expires = "False"
  }
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

resource "azurerm_storage_container" "tfbackend" {
  name                  = "tfstate-sandbox"
  storage_account_name  = azurerm_storage_account.tfbackend.name
  container_access_type = "private"
}

output "tfbackend_storage_account_name" {
  value = azurerm_storage_account.tfbackend.name
}
