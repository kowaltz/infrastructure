/*
resource "azurerm_management_group" "shared_infrastructure" {
  display_name               = "mg-shared_infrastructure"
  parent_management_group_id = azurerm_management_group.kowaltz.id
  provider = azurerm.account-provider-azure_root
}

resource "azurerm_management_group" "shared_infrastructure-env" {
  for_each                   = local.set_of_environments
  display_name               = "mg-shared_infrastructure-${each.value}"
  parent_management_group_id = azurerm_management_group.shared_infrastructure.id
  provider = azurerm.account-provider-azure_root
}

resource "azurerm_subscription" "network-env" {
  for_each          = local.set_of_environments
  subscription_name = "subscription-network-${each.value}"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.kowaltz.id
  provider = azurerm.account-provider-azure_root
}
*/