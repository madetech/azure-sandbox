data "azurerm_subscription" "primary" {
}

resource "azurerm_resource_group" "governancefunc" {
  name     = "rg-governance-functions"
  location = var.region
  tags = {
    Expires = "False"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}
resource "random_string" "governancefunc_account_name" {
  length = 8

  numeric = true
  lower   = true

  special = false
  upper   = false
}

resource "azurerm_storage_account" "governancefunc" {
  name                     = "stgovernancefunc${random_string.governancefunc_account_name.result}"
  resource_group_name      = azurerm_resource_group.governancefunc.name
  location                 = azurerm_resource_group.governancefunc.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  tags = {
    Expires = "False"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_storage_container" "governancefunc" {
  name                  = "governancefunctionsdeployment"
  storage_account_name  = azurerm_storage_account.governancefunc.name
  container_access_type = "private"
}

data "archive_file" "governancefunc" {
  type        = "zip"
  output_path = "GovernanceFunctions.zip"
  source_dir  = "${path.root}/GovernanceFunctions"
}

resource "azurerm_storage_blob" "governancefunc" {

  name                   = "${data.archive_file.governancefunc.output_base64sha256}.zip"
  storage_account_name   = azurerm_storage_account.governancefunc.name
  storage_container_name = azurerm_storage_container.governancefunc.name
  type                   = "Block"
  source                 = data.archive_file.governancefunc.output_path
  content_md5            = data.archive_file.governancefunc.output_md5
}

resource "azurerm_service_plan" "governancefunc" {
  name                = "plan-governancefunc"
  resource_group_name = azurerm_resource_group.governancefunc.name
  location            = azurerm_resource_group.governancefunc.location
  os_type             = "Windows"
  sku_name            = "Y1"
  tags = {
    Expires = "False"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_log_analytics_workspace" "governancefunc" {
  name                = "log-governancefunc"
  location            = azurerm_resource_group.governancefunc.location
  resource_group_name = azurerm_resource_group.governancefunc.name
  sku                 = "PerGB2018"
  retention_in_days   = 90

  tags = {
    Expires = "False"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_application_insights" "governancefunc" {
  name                = "appi-governancefunc"
  location            = azurerm_resource_group.governancefunc.location
  resource_group_name = azurerm_resource_group.governancefunc.name
  workspace_id        = azurerm_log_analytics_workspace.governancefunc.id
  application_type    = "web"

  tags = {
    Expires = "False"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_windows_function_app" "governancefunc" {
  name                = "func-governancefunc"
  resource_group_name = azurerm_resource_group.governancefunc.name
  location            = azurerm_resource_group.governancefunc.location

  service_plan_id = azurerm_service_plan.governancefunc.id

  storage_account_name       = azurerm_storage_account.governancefunc.name
  storage_account_access_key = azurerm_storage_account.governancefunc.primary_access_key

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.governancefunc.instrumentation_key
    WEBSITE_RUN_FROM_PACKAGE       = "https://${azurerm_storage_account.governancefunc.name}.blob.core.windows.net/${azurerm_storage_container.governancefunc.name}/${urlencode(azurerm_storage_blob.governancefunc.name)}",
  }

  site_config {}
  tags = {
    Expires = "False"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_role_assignment" "governancefunc" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_windows_function_app.governancefunc.identity[0].principal_id
}

# Allow our function's managed identity to have r/w access to the storage account
resource "azurerm_role_assignment" "governancefunc_storage" {
  principal_id         = azurerm_windows_function_app.governancefunc.identity[0].principal_id
  scope                = azurerm_storage_account.governancefunc.id
  role_definition_name = "Storage Blob Data Reader"
}

resource "azurerm_monitor_diagnostic_setting" "governancefunc" {
  name                       = "diag-governancefunc"
  target_resource_id         = azurerm_windows_function_app.governancefunc.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.governancefunc.id

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
  name = "evgt-resource-events"

  resource_group_name = azurerm_resource_group.governancefunc.name
  location            = "global"

  source_arm_resource_id = data.azurerm_subscription.primary.id
  topic_type             = "Microsoft.Resources.Subscriptions"
  tags = {
    Expires = "False"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_eventgrid_system_topic_event_subscription" "resource_events" {
  name                = "evgs-resource-events"
  system_topic        = azurerm_eventgrid_system_topic.resource_events.name
  resource_group_name = azurerm_resource_group.governancefunc.name
  azure_function_endpoint {
    function_id = "${azurerm_windows_function_app.governancefunc.id}/functions/ResourceTagger"

    # defaults, specified to avoid "no-op" changes when 'apply' is re-ran
    max_events_per_batch              = 1
    preferred_batch_size_in_kilobytes = 64
  }

  depends_on = [
    azurerm_storage_blob.governancefunc # wait for functions to be deployed
  ]
}
