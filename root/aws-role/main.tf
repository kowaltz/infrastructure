# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

locals {
  organization = yamldecode(file(var.path_architecture_yaml)).organization

  root_role_name = "${local.organization}-iam-role-root-spacelift_${var.aws_oidc_enabled ? "oidc" : "default"}"
}

output "root_role_name" {
  value = local.root_role_name
}