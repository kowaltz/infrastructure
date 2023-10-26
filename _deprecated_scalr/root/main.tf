provider "scalr" {
  hostname = var.hostname
  token    = var.api_token
}


# VCS Provider
data "scalr_vcs_provider" "github" {
  name       = "Kowaltz"
  account_id = var.account_id
  vcs_type   = "github"
}

locals {
  azure_root_credentials = {
    client_id       = var.azure_root_credentials_client_id,
    subscription_id = var.azure_root_credentials_subscription_id,
    tenant_id       = var.azure_root_credentials_tenant_id,
  }

  path_scalr_dir = "infrastructure/scalr"

  set_of_environments    = toset(["dev", "prod"])
  set_of_cloud_providers = toset(["aws", "azure"])

  list_of_cloud_provider_configurations = [
    for i in local.set_of_cloud_providers :
    {
      id    = module.providers-cloud_root.ids[i]
      alias = module.providers-cloud_root.names[i]
    }
  ]

  vcs_provider_id = data.scalr_vcs_provider.github.id
}


# Minimal role with 'accounts:read' permission
resource "scalr_role" "accounts_read" {
  name        = "account-role-accounts_read"
  account_id  = var.account_id
  description = "Minimal role with 'accounts:read' permission."

  permissions = [
    "accounts:read",
  ]
}


# Create other environments
resource "scalr_environment" "env" {
  for_each                        = local.set_of_environments
  name                            = "account-environment-${each.value}"
  account_id                      = var.account_id
  cost_estimation_enabled         = true
  policy_groups                   = []
  default_provider_configurations = []
}