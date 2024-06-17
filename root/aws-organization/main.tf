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

  map_of_account_details = each.value.aws-accounts
  name                   = each.key
  parent_id              = aws_organizations_organizational_unit.root.id
  organization           = var.organization
  set_of_environments    = each.value.environments == "all" ? local.org_structure.environments : toset([each.value.environments])
  unique_identifier      = local.unique_identifier
}

module "aws-spacelift-integration" {
  for_each = module.aws-organization-ou.set_of_accounts_created
  source   = "../../modules/aws-spacelift-integration"

  account_id              = each.value.account_id
  account_details         = each.value.account_details
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
  description          = "Space for managing AWS infrastructure for the account ${each.value.path}/${each.value.account_details.name}."
  enable_local_preview = true
  labels = [
    "${var.organization}-context-root-aws",
    "${var.organization}-context-organization"
  ]
  name                    = each.value.trusted_stack_name
  project_root            = "env/${each.value.ou_name}/${each.value.account_details.name}"
  repository              = var.repository
  space_id                = each.value.env
  terraform_version       = var.terraform_version
  terraform_workflow_tool = "OPEN_TOFU"
}

locals {
  set_of_dependencies = toset(flatten([
    for account in module.aws-organization-ou.set_of_accounts_created : [
      for dependency in account.account_details.dependencies : {
        account.account_details.name = dependency
    }]
  ]))
}

data "spacelift_stack" "dependents" {
  for_each = local.set_of_dependencies
  stack_id = each.key
}

data "spacelift_stack" "dependencies" {
  for_each = local.set_of_dependencies
  stack_id = each.value
}

resource "spacelift_stack_dependency" "env_account-on-root_aws_organization" {
  for_each = local.set_of_dependencies
  
  stack_id            = data.spacelift_stack.dependents[each.key]
  depends_on_stack_id = data.spacelift_stack.dependencies[each.value]
}