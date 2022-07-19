resource "azurerm_subscription_policy_assignment" "tag_governance" {
  name                 = "tag_governance"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = var.tag_governance_policyset_id
  description          = "Assignment of the Tag Governance initiative to subscription."
  display_name         = "Tag Governance"
  location             = var.region
  identity { type = "SystemAssigned" }
}