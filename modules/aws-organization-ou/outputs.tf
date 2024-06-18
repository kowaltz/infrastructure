output "set_of_accounts_created" {
  value = toset([
    for k, v in module.aws_organization_env_account : {
      account_id      = v.id
      account_details = v.details
      env             = v.env
      parent_id       = v.parent_id
      parent_name     = var.name
    }
  ])
}