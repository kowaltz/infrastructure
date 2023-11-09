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

resource "aws_organizations_organizational_unit" "org_root" {
  name      = "${var.organization}-organizations-ou-root"
  parent_id = var.aws_organization_root_id
}