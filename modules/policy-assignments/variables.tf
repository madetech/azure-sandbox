data "azurerm_subscription" "current" {
}

variable "region" {
  type        = string
  description = "The region to apply policy assignments"
}

variable "tag_governance_policyset_id" {
  type        = string
  description = "The policy set definition id for tag_governance"
}