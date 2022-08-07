resource "azurerm_resource_group" "cloudshell_northeurope" {
  name     = "cloud-shell-storage-northeurope"
  location = var.cloud_shell_region
  tags = {
    Expires = "False"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "random_string" "cloud_shell_storage_account_name" {
  length = 18

  numeric = true
  lower   = true

  special = false
  upper   = false
}

resource "azurerm_storage_account" "cloudshell_northeurope" {
  name                     = "stcsne${random_string.cloud_shell_storage_account_name.result}"
  resource_group_name      = azurerm_resource_group.cloudshell_northeurope.name
  location                 = azurerm_resource_group.cloudshell_northeurope.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    Expires = "False"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}
