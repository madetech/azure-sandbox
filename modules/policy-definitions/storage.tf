resource "azurerm_policy_definition" "restrictCloudShellStorage" {
  name         = "restrictCloudShellStorage"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Restrict CloudShell automatic storage accounts"
  description  = "Block users from creating storage accounts through the ui, to encourage use of the centrally managed one"

  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [{
          "field" : "type",
          "equals" : "Microsoft.Storage/storageAccounts"
          },
          {
            "field" : "tags.ms-resource-usage",
            "equals" : "azure-cloud-shell"
          }
        ]
      },
      "then" : {
        "effect" : "deny"
      }
    }
  )
}
