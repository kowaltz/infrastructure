resource "aws_organizations_organizational_unit" "infrastructure" {
  name      = "${var.organization}-ou-root-infrastructure"
  parent_id = aws_organizations_organizational_unit.org_root.id
}

resource "aws_organizations_organizational_unit" "infrastructure-env" {
  for_each  = var.set_of_environments
  name      = "${var.organization}-ou-root_infrastructure-${each.value}"
  parent_id = aws_organizations_organizational_unit.infrastructure.id
}

/*
resource "aws_organizations_account" "network-env" {
  for_each          = local.set_of_environments
  name              = "account-network-${each.value}"
  email             = "account-network-${each.value}@kowaltz.com"
  close_on_deletion = true
  parent_id         = aws_organizations_organizational_unit.shared_infrastructure-env[each.value].id
}
*/

locals {
  version = "0.0.1"
}

resource "random_pet" "resource_version" {
  keepers = {
    version = local.version
  }
}

resource "aws_organizations_account" "env-vms" {
  for_each          = var.set_of_environments
  name              = "${var.organization}-account-root_infrastructure_${each.value}-vms.${random_pet.resource_version.id}"
  email             = "account-root_infrastructure_${each.value}-vms.${random_pet.resource_version.id}@${var.organization}.com"
  close_on_deletion = true
  parent_id         = aws_organizations_organizational_unit.infrastructure-env[each.value].id
}

module "oidc_provider-github-infrastructure" {
  depends_on = [ aws_iam_openid_connect_provider.github_actions ]
  for_each = var.set_of_environments
  source = "../modules/oidc_provider-github"

  aws_account_id = aws_organizations_account.env-vms[each.value].id
  env = each.value
  github_repo = "infrastructure"
}