output "tag_governance_assignment_id" {
  value       = azurerm_subscription_policy_assignment.tag_governance.id
  description = "The policy assignment id for tag_governance"
}

output "tag_governance_assignment_identity" {
  value       = azurerm_subscription_policy_assignment.tag_governance.identity
  description = "The policy assignment identity for tag_governance"
}

output "storage_account_governance_assignment_id" {
  value       = azurerm_subscription_policy_assignment.storage_account_governance.id
  description = "The policy assignment id for storage_account_governance"
}

output "storage_account_governance_assignment_identity" {
  value       = azurerm_subscription_policy_assignment.storage_account_governance.identity
  description = "The policy assignment identity for storage_account_governance"
}
