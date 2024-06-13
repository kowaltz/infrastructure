output "set_of_accounts_created" {
  value = toset([
    for k, v in module.aws_organization_env_account : {
      account_id      = v.id
      account_name    = v.name
      env             = v.env
      parent_id       = v.parent_id
      set_of_policies = v.set_of_policies
    }
  ])
}