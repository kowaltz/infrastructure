provider "spacelift" {}

data "spacelift_stack" "root-spacelift" {
  stack_id = "${local.organization}-stack-root-spacelift"
}

locals {
  config = yamldecode(file(var.path_config_yaml))
  environments = local.config.environments
  organization = local.config.organization
  repository = local.config.repository
  tf_version = local.config.tf_version

  aws_role_name = "arn:aws:iam::${var.aws_account_id}:role/${local.organization}-role-root-spacelift_default"

  context_root_aws_name = "${local.organization}-context-root-aws"
}

resource "spacelift_aws_integration" "root" {
  name = "${local.organization}-aws_integration-root"

  # We need to set the ARN manually rather than referencing the role to avoid a circular dependency
  role_arn                       = local.aws_role_name
  generate_credentials_in_worker = false
  space_id                       = "root"
}