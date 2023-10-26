module "providers-scalr_env" {
  source = "../../../../modules/scalr/providers/terraform-scalr-scalr_env"

  account_id                      = var.account_id
  hostname                        = var.hostname
  env                             = var.env
  list_of_shared_environments_ids = [var.scalr_environment_id]
  list_of_roles_ids = [
    scalr_role.scope_account.id,
    scalr_role.scope_environment.id
  ]
}