# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

data "aws_organizations_organization" "root" {}

locals {
  org_id      = data.aws_organizations_organization.root.id
  org_root_id = data.aws_organizations_organization.root.roots[0].id

  unique_identifier = sha1(var.plan_version)

  org_structure = yamldecode(file(var.path_org_structure_yaml))
}

resource "aws_organizations_organizational_unit" "root" {
  name      = "${var.organization}-ou-root"
  parent_id = local.org_root_id
}

module "aws_organization_structure" {
  for_each = local.org_structure.organizational-units
  source   = "../../modules/aws-organization-ou"

  name                = each.key
  parent_id           = aws_organizations_organizational_unit.root.id
  organization        = var.organization
  set_of_accounts     = each.value.accounts
  set_of_environments = each.value.per-environment ? local.org_structure.environments : []
  unique_identifier   = local.unique_identifier
}