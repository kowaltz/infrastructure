resource "aws_organizations_organizational_unit" "name" {
  name      = "${var.organization}-ou-${var.name}"
  parent_id = var.parent_id
}

resource "aws_organizations_organizational_unit" "name-env" {
  for_each = var.set_of_environments

  name      = "${var.organization}-ou-${var.name}-${each.value}"
  parent_id = aws_organizations_organizational_unit.name.id
}

locals {
  set_of_parents = toset([
    for env in var.set_of_environments : {
      env  = env
      id   = aws_organizations_organizational_unit.name-env[env].id
    }
  ])

  set_of_account_details = [
    for parent in local.set_of_parents : [
      for account in var.map_of_accounts_and_policies : {
        account         = account.name
        env             = parent.env
        parent_id       = parent.id
        set_of_policies = account.managed-policies
      }
    ]
  ]
}

module "aws_organization_env_account" {
  for_each = local.set_of_account_details
  source   = "../aws-organization-account"

  account_name      = each.value.account
  env               = each.value.env
  parent_id         = each.value.parent_id
  parent_name       = var.name
  set_of_policies   = each.value.set_of_policies
  organization      = var.organization
  unique_identifier = var.unique_identifier
}