resource "aws_organizations_organizational_unit" "name" {
  name      = "${var.organization}-ou-${var.name}"
  parent_id = var.parent_id
}

resource "aws_organizations_organizational_unit" "name-env" {
  for_each  = var.set_of_environments

  name      = "${var.organization}-ou-${var.name}-${each.value}"
  parent_id = aws_organizations_organizational_unit.name.id
}

locals {
  set_of_accounts = {
    for env in var.set_of_environments: env => {
      name = "${var.organization}-account-${var.name}_${account}"
      email = "account-${var.name}_${account}@${var.organization}.com"
    }
  }
}

module "aws_organization_env_account" {
  for_each = var.set_of_environments
  source   = "../aws-organization-account"

  name              = var.name
  parent_id         = var.env ? (
    aws_organizations_organizational_unit.name-env[each.value].id
  ) : (
    aws_organizations_organizational_unit.name.id
  )
  path              = "${var.name}_${each.value}"
  organization      = var.organization
  unique_identifier = var.unique_identifier
}