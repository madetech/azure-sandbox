output "tag_governance_policyset_id" {
  value       = azurerm_policy_set_definition.tag_governance.id
  description = "The policy set definition id for tag_governance"
}