resource "aws_organizations_organizational_unit" "workloads" {
  name      = "${var.organization}-ou-root-workloads"
  parent_id = aws_organizations_organizational_unit.org_root.id
}

resource "aws_organizations_organizational_unit" "workloads-env" {
  for_each  = local.set_of_environments
  name      = "${var.organization}-ou-root_workloads-${each.value}"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

/*
resource "aws_organizations_account" "vault-env" {
  for_each          = local.set_of_environments
  name              = "account-vault-${each.value}"
  email             = "account-vault-${each.value}@kowaltz.com"
  close_on_deletion = true
  parent_id         = aws_organizations_organizational_unit.workloads-env[each.value].id
  provider = aws.account-provider-aws_root
}
*/

module "oidc_provider-github-workloads" {
  depends_on = [ aws_iam_openid_connect_provider.github_actions ]
  for_each = var.set_of_environments
  source = "../modules/oidc_provider-github"

  aws_account_id = var.aws_account_id
  env = each.value
  github_repo = "monorepo"
}