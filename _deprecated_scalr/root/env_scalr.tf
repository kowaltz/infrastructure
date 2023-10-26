# Scalr environment
resource "scalr_role" "root" {
  name        = "account-role-root"
  account_id  = var.account_id
  description = "Root-level access for managing Scalr infrastructure."

  permissions = [
    "accounts:read",
    "accounts:set-access-policies",

    "cloud-credentials:create",
    "cloud-credentials:delete",
    "cloud-credentials:read",
    "cloud-credentials:update",

    "environments:create",
    "environments:delete",
    "environments:read",
    "environments:set-access-policies",
    "environments:update",

    "identity-providers:create",
    "identity-providers:delete",
    "identity-providers:read",
    "identity-providers:update",

    "modules:create",
    "modules:delete",
    "modules:read",
    "modules:update",

    "roles:create",
    "roles:delete",
    "roles:read",
    "roles:update",

    "service-accounts:create",
    "service-accounts:delete",
    "service-accounts:read",
    "service-accounts:update",

    "variables:create",
    "variables:delete",
    "variables:read",
    "variables:update",

    "vcs-providers:read",

    "workspaces:create",
    "workspaces:delete",
    "workspaces:lock",
    "workspaces:read",
    "workspaces:set-access-policies",
    "workspaces:set-schedule",
    "workspaces:update",
  ]
}

module "provider-scalr_root" {
  source = "../../modules/scalr/providers/terraform-scalr-scalr_env"

  account_id                      = var.account_id
  hostname                        = var.hostname
  env                             = "root"
  list_of_shared_environments_ids = ["env-v0o1dsqd77umjedt0"]
  list_of_roles_ids               = [scalr_role.root.id]
}


resource "scalr_environment" "scalr" {
  name                            = "account-environment-scalr"
  account_id                      = var.account_id
  cost_estimation_enabled         = true
  policy_groups                   = []
  default_provider_configurations = []
}


# Workspaces in "scalr" environment:
# - "root" workspace.
# - "dev" & "prod" workspaces.
module "scalr-workspace-root" {
  source = "../../modules/scalr/terraform-scalr-workspace"

  branch         = "prod"
  environment_id = scalr_environment.scalr.id
  name           = "scalr-workspace-root"
  list_of_provider_configurations = [
    {
      id    = module.provider-scalr_root.id
      alias = module.provider-scalr_root.name
    }
  ]
  vcs_provider_id   = local.vcs_provider_id
  working_directory = "${local.path_scalr_dir}/root"
}

module "scalr_workspace_env" {
  for_each = local.set_of_environments
  source   = "./modules/scalr-workspace-env"

  account_id                      = var.account_id
  hostname                        = var.hostname
  path_scalr_dir                  = local.path_scalr_dir
  scalr_environment_id            = scalr_environment.scalr.id
  list_of_provider_configurations = local.list_of_cloud_provider_configurations
  env                             = each.value
  vcs_provider_id                 = local.vcs_provider_id
}