module "aws_organizations_account" {
  for_each = var.set_of_environments
  source   = "../modules/organizations-account"

  list_of_stack_permissions = [
    "${var.organization}-github@*@${var.organization}-stack-${each.value}-aws_infrastructure_vms@*",
    "${var.organization}-github@*@${var.organization}-stack-${each.value}-spacelift@*",
  ]
  name              = "vms"
  parent_id         = aws_organizations_organizational_unit.infrastructure-env[each.value].id
  path              = "root_infrastructure_${each.value}"
  organization      = var.organization
  unique_identifier = local.unique_identifier
}

/*
output "infrastructure_env_vms_id" {
  value = { for env in var.set_of_environments :
    env => module.aws_organizations_account.id
  }
}
*/

module "oidc_provider-github-infrastructure" {
  depends_on = [aws_iam_openid_connect_provider.github_actions]
  for_each   = var.set_of_environments
  source     = "../modules/oidc_provider-github"

  aws_account_id = module.aws_organizations_account[each.value].id
  env            = each.value
  github_repo    = "infrastructure"
}