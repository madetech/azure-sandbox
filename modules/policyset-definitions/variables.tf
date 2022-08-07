variable "policyset_definition_category" {
  type        = string
  description = "The category to use for all PolicySet defintions"
  default     = "Custom"
}

variable "custom_policies_tag_governance" {
  type        = list(map(string))
  description = "List of custom policy definitions for the tag_governance policyset"
  default     = []
}

variable "custom_policies_storage_account_governance" {
  type        = list(map(string))
  description = "List of custom policy definitions for the storage_account_governance policyset"
  default     = []
}