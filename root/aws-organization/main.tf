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
  depends_on = [aws_iam_policy_attachment.org_manage]
  name       = "${var.organization}-ou-root"
  parent_id  = local.org_root_id
}

module "aws-organization-ou" {
  for_each = local.org_structure.aws-organizational-units
  source   = "../../modules/aws-organization-ou"

  map_of_accounts_and_policies = each.value.aws-accounts
  name                         = each.key
  parent_id                    = aws_organizations_organizational_unit.root.id
  organization                 = var.organization
  set_of_environments          = each.value.environments == "all" ? local.org_structure.environments : toset([each.value.environments])
  unique_identifier            = local.unique_identifier
}

module "aws-spacelift-integration" {
  for_each = module.aws-organization-ou.set_of_accounts_created
  source   = "../../modules/aws-spacelift-integration"

  account_id              = each.value.account_id
  account_name            = each.value.account_name
  aws_region              = var.aws_region
  env                     = each.value.env
  path                    = each.value.path
  organization            = var.organization
  ou_id                   = each.value.parent_id
  ou_name                 = each.value.parent_name
  set_of_managed_policies = each.value.set_of_policies
}

resource "spacelift_stack" "account_created" {
  for_each = module.aws-spacelift-integration

  administrative       = false
  autodeploy           = false
  branch               = each.value.env
  description          = "Space for managing AWS infrastructure for the account ${each.value.path}/${each.value.account_name}."
  enable_local_preview = true
  labels = [
    "${var.organization}-context-root-aws",
    "${var.organization}-context-organization"
  ]
  name                    = each.value.trusted_stack_name
  project_root            = "env/${each.value.ou_name}/${each.value.account_name}"
  repository              = var.repository
  space_id                = each.value.env
  terraform_version       = var.terraform_version
  terraform_workflow_tool = "OPEN_TOFU"
}