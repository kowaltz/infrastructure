# For each environment,
# 1) Create a service account,
# 2) Generate a service account token,
# 3) And use it to create a Scalr provider
resource "scalr_service_account" "account-service_account-scalr_env" {
  name        = "account-service_account-scalr_${var.env}"
  description = "There must be one service account for each provider with a different set of permissions. This is for ${var.env} workloads."
  status      = "Active"
  account_id  = var.account_id
}


resource "scalr_access_policy" "roles" {
  subject {
    type = "service_account"
    id   = scalr_service_account.account-service_account-scalr_env.id
  }
  scope {
    type = "account"
    id   = var.account_id
  }

  role_ids = var.list_of_roles_ids
}


resource "scalr_service_account_token" "account-token-scalr_env" {
  service_account_id = scalr_service_account.account-service_account-scalr_env.id
  description        = "Token for the service account."
  depends_on         = [scalr_access_policy.roles]
}


resource "scalr_provider_configuration" "scalr_env" {
  name                   = "account-provider-scalr_${var.env}"
  account_id             = var.account_id
  environments           = var.list_of_shared_environments_ids
  export_shell_variables = false
  scalr {
    hostname = var.hostname
    token    = scalr_service_account_token.account-token-scalr_env.token
  }
}