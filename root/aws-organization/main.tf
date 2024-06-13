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
  depends_on = [ aws_iam_policy_attachment.org_manage ]
  name      = "${var.organization}-ou-root"
  parent_id = local.org_root_id
}

module "aws-organization-ou" {
  for_each = local.org_structure.organizational-units
  source   = "../../modules/aws-organization-ou"

  name                = each.key
  parent_id           = aws_organizations_organizational_unit.root.id
  organization        = var.organization
  set_of_accounts     = each.value.accounts
  set_of_environments = each.value.per-environment ? local.org_structure.environments : []
  unique_identifier   = local.unique_identifier
}

module "aws-spacelift-integration" {
  for_each = module.aws-organization-ou.set_of_accounts_created
  source = "../../modules/aws-spacelift-integration"

  account_id = each.value.account_id
  account_name = each.value.account_name
  aws_region = var.aws_region
  path = each.value.path
  organization = var.organization
  ou_id = each.value.parent_id
  space_id =
}

resource "spacelift_stack" "root-aws_integrations" {
  administrative       = false
  autodeploy           = false
  branch               = "prod"
  description          = "Space for managing root-level integrations to AWS."
  enable_local_preview = true
  labels = [
    local.context_root_aws_name,
    local.context_organization_name
  ]
  name                    = "${var.organization}-stack-root-aws_integrations"
  project_root            = "root/aws-integrations"
  repository              = var.repository
  space_id                = "root"
  terraform_version       = var.terraform_version
  terraform_workflow_tool = "OPEN_TOFU"
}