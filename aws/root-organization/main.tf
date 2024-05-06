# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  /* WITH OIDC
  assume_role_with_web_identity {
    role_arn                = local.root_role_arn
    web_identity_token_file = "/mnt/workspace/spacelift.oidc"
  }
  */
}

data "aws_organizations_organization" "root" {}

locals {
  org_id      = data.aws_organizations_organization.root.id
  org_root_id = data.aws_organizations_organization.root.roots[0].id

  unique_identifier = sha1(var.plan_version)
}

resource "aws_organizations_organizational_unit" "org_root" {
  depends_on = [
    aws_iam_policy.manage_organization,
    aws_iam_policy_attachment.manage_organization
  ]
  name      = "${var.organization}-ou-root"
  parent_id = local.org_root_id
}