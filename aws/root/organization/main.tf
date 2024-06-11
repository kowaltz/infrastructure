# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}


data "aws_organizations_organization" "root" {
  depends_on = [ aws_iam_policy_attachment.org_read ]
}

locals {
  org_id      = data.aws_organizations_organization.root.id
  org_root_id = data.aws_organizations_organization.root.roots[0].id

  unique_identifier = sha1(var.plan_version)
}

resource "aws_organizations_organizational_unit" "root" {
  name      = "${var.organization}-ou-root"
  parent_id = local.org_root_id
}