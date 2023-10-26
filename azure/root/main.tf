provider "azurerm" {
  alias = "account-provider-azure_root"
  
  features {
    subscription {
      prevent_cancellation_on_destroy = true
    }
  }

  use_oidc        = true
  client_id       = var.arm_root_client_id
  subscription_id = var.arm_root_subscription_id
  tenant_id       = var.arm_root_tenant_id
}

locals {
  set_of_environments = toset(["dev", "prod"])
}
/*
resource "azurerm_management_group" "kowaltz" {
  display_name = "kowaltz"
  provider = azurerm.account-provider-azure_root
}
*/
data "azurerm_billing_mca_account_scope" "kowaltz" {
  billing_account_name = var.azure_billing_account_name
  billing_profile_name = var.azure_billing_profile_name
  invoice_section_name = var.azure_invoice_section_name
}
