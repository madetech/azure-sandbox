data "azurerm_subscription" "primary" {
}

resource "azurerm_resource_group" "cleanupfunc" {
  name     = "rg-cleanup-functions"
  location = var.region
  tags = {
    "Expires" = "False"
  }
  lifecycle {
    ignore_changes = [tags]
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
  lifecycle {
    ignore_changes = [tags]
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
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_log_analytics_workspace" "cleanupfunc" {
  name                = "log-cleanupfunc"
  location            = azurerm_resource_group.cleanupfunc.location
  resource_group_name = azurerm_resource_group.cleanupfunc.name
  sku                 = "PerGB2018"
  retention_in_days   = 90

  tags = {
    "Expires" = "False"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_application_insights" "cleanupfunc" {
  name                = "appi-cleanupfunc"
  location            = azurerm_resource_group.cleanupfunc.location
  resource_group_name = azurerm_resource_group.cleanupfunc.name
  workspace_id        = azurerm_log_analytics_workspace.cleanupfunc.id
  application_type    = "web"

  tags = {
    "Expires" = "False"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}


resource "azurerm_function_app" "cleanupfunc" {
  name                = "func-cleanupfunc"
  resource_group_name = azurerm_resource_group.cleanupfunc.name
  location            = azurerm_resource_group.cleanupfunc.location

  app_service_plan_id = azurerm_service_plan.cleanupfunc.id

  storage_account_name       = azurerm_storage_account.cleanupfunc.name
  storage_account_access_key = azurerm_storage_account.cleanupfunc.primary_access_key

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.cleanupfunc.instrumentation_key
    WEBSITE_RUN_FROM_PACKAGE       = "1"
  }
  version = "~4"

  site_config {}
  tags = {
    "Expires" = "False"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_role_assignment" "cleanupfunc" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_function_app.cleanupfunc.identity[0].principal_id
}

resource "azurerm_monitor_diagnostic_setting" "cleanupfunc" {
  name                       = "diag-cleanupfunc"
  target_resource_id         = azurerm_function_app.cleanupfunc.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.cleanupfunc.id

  log {
    category = "FunctionAppLogs"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_eventgrid_system_topic" "resource_events" {
  count                  = var.are_functions_deployed ? 1 : 0
  name                   = "evgt-resource-events"

  resource_group_name    = azurerm_resource_group.cleanupfunc.name
  location               = "global"

  source_arm_resource_id = data.azurerm_subscription.primary.id
  topic_type             = "Microsoft.Resources.Subscriptions"
  tags = {
    "Expires" = "False"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_eventgrid_system_topic_event_subscription" "resource_events" {
  count = var.are_functions_deployed ? 1 : 0
  name  = "evgs-resource-events"
  system_topic        = azurerm_eventgrid_system_topic.resource_events[0].name
  resource_group_name = azurerm_resource_group.cleanupfunc.name
  azure_function_endpoint {
    function_id = "${azurerm_function_app.cleanupfunc.id}/functions/ResourceTagger"

    # defaults, specified to avoid "no-op" changes when 'apply' is re-ran
    max_events_per_batch              = 1
    preferred_batch_size_in_kilobytes = 64
  }
}

