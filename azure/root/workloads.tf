/*
resource "azurerm_management_group" "workloads" {
  display_name               = "mg-workloads"
  parent_management_group_id = azurerm_management_group.kowaltz.id
  provider = azurerm.account-provider-azure_root
}

resource "azurerm_management_group" "workloads-env" {
  for_each                   = local.set_of_environments
  display_name               = "mg-workloads-${each.value}"
  parent_management_group_id = azurerm_management_group.workloads.id
  provider = azurerm.account-provider-azure_root
}

resource "azurerm_subscription" "vault-env" {
  for_each          = local.set_of_environments
  subscription_name = "subscription-vault-${each.value}"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.kowaltz.id
  provider = azurerm.account-provider-azure_root
}
*/