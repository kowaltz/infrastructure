output "set_of_accounts_created" {
  value = toset([
    for k, v in module.aws_organization_env_account : {
      parent_id    = v.parent_id
      path         = v.path
      account_id   = v.id
      account_name = v.name
    }
  ])
}