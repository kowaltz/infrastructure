resource "scalr_role" "scope_account" {
  name        = "account-role-scalr_scope_account_${var.env}"
  account_id  = var.account_id
  description = "Minimum access for managing Scalr infrastructure."

  permissions = [
    "accounts:read",
    "cloud-credentials:*",
    "identity-providers:create",
    "identity-providers:read",
    "identity-providers:update",
    "roles:*",
    "service-accounts:read",
    "variables:*",
    "vcs-providers:read",
  ]
}

resource "scalr_role" "scope_environment" {
  name        = "account-role-scalr_scope_environment_${var.env}"
  account_id  = var.account_id
  description = "Minimum access for managing Scalr infrastructure."

  permissions = [
    "accounts:read",
    "cloud-credentials:*",
    "environments:read",
    "environments:set-access-policies",
    "environments:update",
    "workspaces:*",
  ]
}

resource "scalr_access_policy" "scalr_env_scope_account" {
  subject {
    type = "service_account"
    id   = module.providers-scalr_env.service_account_id
  }
  scope {
    type = "account"
    id   = var.account_id
  }

  role_ids = [
    scalr_role.scope_account.id
  ]
}

resource "scalr_access_policy" "scalr_env_scope_environment" {
  subject {
    type = "service_account"
    id   = module.providers-scalr_env.service_account_id
  }
  scope {
    type = "environment"
    id   = var.scalr_environment_id
  }

  role_ids = [
    scalr_role.scope_environment.id
  ]
}
