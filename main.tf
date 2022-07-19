terraform {
  required_providers {
    azurerm = {
      version = "3.14.0"
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

  region                      = var.default_region
  tag_governance_policyset_id = module.policyset_definitions.tag_governance_policyset_id
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
    }
  ]

}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "linuxfunctionappsa"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "example" {
  name                = "example-app-service-plan"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "example" {
  name                = "example-linux-function-app"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  storage_account_name = azurerm_storage_account.example.name
  service_plan_id      = azurerm_service_plan.example.id

  site_config {}
}
