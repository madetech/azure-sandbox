
resource "azurerm_resource_group" "cleanupfunc" {
  name     = "rg-cleanup-functions"
  location = var.region
  tags = {
    "Expires" = "False"
  }
}

resource "azurerm_storage_account" "cleanupfunc" {
  name                     = "stcleanupfunc"
  resource_group_name      = azurerm_resource_group.cleanupfunc.name
  location                 = azurerm_resource_group.cleanupfunc.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    "Expires" = "False"
  }
}

resource "azurerm_service_plan" "cleanupfunc" {
  name                = "plan-cleanupfunc"
  resource_group_name = azurerm_resource_group.cleanupfunc.name
  location            = azurerm_resource_group.cleanupfunc.location
  os_type             = "Windows"
  sku_name            = "Y1"
  tags = {
    "Expires" = "False"
  }
}

resource "azurerm_linux_function_app" "cleanupfunc" {
  name                = "func-cleanupfunc"
  resource_group_name = azurerm_resource_group.cleanupfunc.name
  location            = azurerm_resource_group.cleanupfunc.location

  storage_account_name = azurerm_storage_account.cleanupfunc.name
  service_plan_id      = azurerm_service_plan.cleanupfunc.id

  site_config {}
  tags = {
    "Expires" = "False"
  }
}
