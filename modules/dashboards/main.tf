resource "azurerm_resource_group" "dashboards" {
  name     = "rg-dashboards"
  location = var.region

  tags = {
    "Expires" = "False"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_dashboard" "resourceoverview" {
  name                = "Resources-Overview"
  resource_group_name = azurerm_resource_group.dashboards.name
  location            = azurerm_resource_group.dashboards.location
  tags = {
    source = "terraform"
  }

  dashboard_properties = templatefile("./modules/dashboards/templates/resources.tpl", {})

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
