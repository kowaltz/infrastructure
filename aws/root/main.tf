# Configure the AWS Provider
provider "aws" {
  region = "eu-south-2"
  /* WITH OIDC
  assume_role_with_web_identity {
    role_arn                = local.root_role_arn
    web_identity_token_file = "/mnt/workspace/spacelift.oidc"
  }
  */
}

data "aws_organizations_organization" "root" {
  depends_on = [
    aws_iam_policy.ou_create_org,
    aws_iam_policy_attachment.ou_create_org
  ]
}

locals {
  org_id = data.aws_organizations_organization.root.id
  org_root_id = data.aws_organizations_organization.root.roots[0].id
}

resource "aws_organizations_organizational_unit" "org_root" {
  name      = "${var.organization}-organizations-ou-root"
  parent_id = "r-${local.org_root_id}"
}