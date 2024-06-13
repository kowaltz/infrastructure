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
  set_of_parents = length(var.set_of_environments) > 0 ? toset([
    for env in var.set_of_environments : {
      path = "${var.name}_${env}"
      id   = aws_organizations_organizational_unit.name-env[env].id
    }
  ]) : toset([
    {
      path = "${var.name}"
      id   = var.parent_id
    }
  ])

  set_of_tuples = [
    for parent in local.set_of_parents : [
      for account in var.set_of_accounts : {
        parent_id = parent.id
        path      = parent.path
        account   = account
      }
    ]
  ]
}

module "aws_organization_env_account" {
  for_each = local.set_of_tuples
  source   = "../aws-organization-account"

  account_name      = each.value.account
  parent_id         = each.value.parent_id
  path              = "${var.name}-${each.value.account}"
  organization      = var.organization
  unique_identifier = var.unique_identifier
}