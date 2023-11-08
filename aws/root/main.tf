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

locals {
  root_role_name = "${var.organization}-iam-role-root-spacelift_${var.aws_oidc_enabled ? "oidc" : "default"}"
  set_of_environments = toset(["dev", "prod"])
}

data "aws_iam_role" "root_role" {
  name = local.root_role_name
}

resource "aws_iam_policy_attachment" "organizations_manage" {
  name       = "organizations_manage"
  roles      = [local.root_role_name]
  policy_arn = aws_iam_policy.manage_organization.arn
}

data "aws_organizations_organization" "root" {
  depends_on = [ aws_iam_policy_attachment.organizations_manage ]
}
