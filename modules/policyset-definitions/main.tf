resource "azurerm_policy_set_definition" "tag_governance" {

  name         = "tag_governance"
  policy_type  = "Custom"
  display_name = "Tag Governance"
  description  = "Contains common Tag Governance policies"

  metadata = jsonencode(
    {
      "category" : "${var.policyset_definition_category}"
    }

  )

  dynamic "policy_definition_reference" {
    for_each = var.custom_policies_tag_governance
    content {
      policy_definition_id = policy_definition_reference.value["policyID"]
      reference_id         = policy_definition_reference.value["policyID"]
    }
  }
}

resource "azurerm_policy_set_definition" "storage_account_governance" {

  name         = "storage_account_governance"
  policy_type  = "Custom"
  display_name = "Storage Account Governance"
  description  = "Contains common Storage Account policies"

  metadata = jsonencode(
    {
      "category" : "${var.policyset_definition_category}"
    }

  )

  dynamic "policy_definition_reference" {
    for_each = var.custom_policies_storage_account_governance
    content {
      policy_definition_id = policy_definition_reference.value["policyID"]
      reference_id         = policy_definition_reference.value["policyID"]
    }
  }
}
