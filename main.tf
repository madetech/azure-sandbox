terraform {
  required_providers {
    azurerm = {
      version = "3.16.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-sandbox"
    storage_account_name = "sttfstatesandbox"
    container_name       = "tfstate-sandbox"
    key                  = "tfstate-sandbox.tfstate"
  }
}

provider "azurerm" {
  features {}
}

module "policy_definitions" {
  source = "./modules/policy-definitions"

}

module "policy_assignments" {
  source = "./modules/policy-assignments"

  region                                  = var.default_region
  tag_governance_policyset_id             = module.policyset_definitions.tag_governance_policyset_id
  storage_account_governance_policyset_id = module.policyset_definitions.storage_account_governance_policyset_id
}

module "policyset_definitions" {
  source = "./modules/policyset-definitions"

  custom_policies_tag_governance = [
    {
      policyID = module.policy_definitions.addTagToRG_policy_ids[0]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRG_policy_ids[0]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRGOverwriteExisting_policy_ids[0]
    },
    {
      policyID = module.policy_definitions.bulkInheritTagsFromRG_policy_id
    },
    {
      policyID = module.policy_definitions.addCreatedOnTag_policy_id
    }
  ]

  custom_policies_storage_account_governance = [
    {
      policyID = module.policy_definitions.restrictCloudShellStorage_policy_id
    }
  ]

}

module "functions" {
  source = "./modules/functions"
  region = var.default_region
  // The functions need to exist before they can wire up the eventgrid subscription
  depends_on = [
    module.policy_assignments # Make sure policy gets applied to these resources
  ]
}

module "dashboards" {
  source = "./modules/dashboards"
  region = var.default_region
  depends_on = [
    module.policy_assignments # Make sure policy gets applied to these resources
  ]
}

module "storage" {
  source             = "./modules/storage"
  cloud_shell_region = "West Europe"
  depends_on = [
    module.policy_assignments # Make sure policy gets applied to these resources
  ]
}
