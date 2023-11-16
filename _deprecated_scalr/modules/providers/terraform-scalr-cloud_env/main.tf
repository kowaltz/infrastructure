# Providers for each cloud provider in the ENV environment
resource "scalr_provider_configuration" "aws" {
  count = contains(var.set_of_cloud_providers, "aws") ? 1 : 0

  name         = "account-provider-aws_${var.env}"
  account_id   = var.account_id
  environments = var.list_of_shared_environments_ids

  aws {
    credentials_type = "oidc"
    role_arn         = var.aws_role_arn
    audience         = var.aws_audience
  }
}

resource "scalr_provider_configuration" "azure" {
  count = contains(var.set_of_cloud_providers, "azure") ? 1 : 0

  name         = "account-provider-azure_${var.env}"
  account_id   = var.account_id
  environments = var.list_of_shared_environments_ids

  azurerm {
    auth_type       = "oidc"
    client_id       = var.azure_credentials["client_id"]
    subscription_id = var.azure_credentials["subscription_id"]
    tenant_id       = var.azure_credentials["tenant_id"]
    audience        = var.azure_audience
  }
}