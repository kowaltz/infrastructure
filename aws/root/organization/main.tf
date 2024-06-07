# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}


resource "aws_organizations_organization" "root" {
  depends_on = [
    aws_iam_policy_attachment.create_organization
  ]

  aws_service_access_principals = [
    "cloudformation.amazonaws.com"
  ]

  feature_set = "ALL"
}

locals {
  org_id      = aws_organizations_organization.root.id
  org_root_id = aws_organizations_organization.root.roots[0].id

  unique_identifier = sha1(var.plan_version)
}

resource "aws_organizations_organizational_unit" "root" {
  depends_on = [
    aws_iam_policy_attachment.manage_organization
  ]

  name      = "${var.organization}-ou-root"
  parent_id = local.org_root_id
}