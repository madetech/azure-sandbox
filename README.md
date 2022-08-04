# azure-sandbox-subscription
An example Azure self-cleaning Azure sandbox subscription

# features

* Require tagging of all resources with an "Expires" tag. Any resources not tagged ```Expires = False``` will be cleaned up.
    * You'll be able to see non-complaint resources in the policy compliance blade, by default the resources for the tf backend are non-compliant, so use these as an example, then tag them so they don't expire.
    * Tags are inherited from parent resource group, so just need to adjust in the one place if resources are needed longer.
* Require tagging of all resources with a "CreatedOn" tag, so you can quickly see how old resources are in case they escape the purge.
* Automatically tag resources with who created/updated them, so you know who owns what.
    * This is suprisingly difficult on Azure, and requires a chunk of manual work, see ResourceTagger function

# pre-requisites

1. Create a new [subscription]https://portal.azure.com/#view/Microsoft_Azure_Billing/SubscriptionsBlade "Link to subscription management blade" for your sandbox. I'd call it sandbox.

Make a note of the subscription id, you'll need this later

2. Create a service principle for Terraform to manage resources in this subscription. WARNING: This service principle will have complete admin priviliges in the subscription, keep it safe.
    * Using azure cli:

```
az ad sp create-for-rbac --name terraform --role Owner --scopes /subscriptions/<subscription_id>
```

3. Create a resource group, storage account and container for your terraform state
    * Using cli: 
```
az group create -l uksouth -n rg-tfstate-sandbox
az storage account create -n sttfstatesandbox -g rg-tfstate-sandbox -l uksouth --sku Standard_ZRS
az storage container create -n tfstate-sandbox --account-name sttfstatesandbox
```
*note: we use zone reduntant storage above for a little added robustness, if you want to bump that up to geo redundant or down to locally redundant is up to you.* 

# references
Policy management reused from:

https://github.com/globalbao/azure-policy-as-code

Cleanup script reused from:

https://github.com/FBoucher/AzSubscriptionCleaner