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
  root_role_name      = "${var.organization}-iam-role-root-spacelift_${var.aws_oidc_enabled ? "oidc" : "default"}"
}

output "root_role_name" {
  value = local.root_role_name
}