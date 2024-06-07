resource "aws_organizations_organizational_unit" "workloads" {
  name      = "${var.organization}-ou-root-workloads"
  parent_id = aws_organizations_organizational_unit.root.id
}

resource "aws_organizations_organizational_unit" "workloads-env" {
  for_each  = var.set_of_environments
  name      = "${var.organization}-ou-root_workloads-${each.value}"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

/*
resource "aws_organizations_account" "env-vms" {
  for_each          = var.set_of_environments
  name              = "${var.organization}-account-root_infrastructure_${each.value}-vms"
  email             = "account-root_infrastructure_${each.value}-vms@${var.organization}.com"
  close_on_deletion = true
  parent_id         = aws_organizations_organizational_unit.infrastructure-env[each.value].id
}

module "oidc_provider-github-workloads" {
  depends_on = [ aws_iam_openid_connect_provider.github_actions ]
  for_each = var.set_of_environments
  source = "../modules/oidc_provider-github"

  aws_account_id = aws_organizations_account.env-vms[each.value].id
  env = each.value
  github_repo = "monorepo"
}
*/