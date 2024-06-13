provider "spacelift" {}

data "spacelift_stack" "root-spacelift" {
  stack_id = "${var.organization}-stack-root-spacelift"
}

locals {
  aws_role_name = "arn:aws:iam::${var.aws_account_id}:role/${var.organization}-iam-role-root-spacelift_default"
}

resource "spacelift_aws_integration" "root" {
  name = "${var.organization}-aws_integration-root"

  # We need to set the ARN manually rather than referencing the role to avoid a circular dependency
  role_arn                       = local.aws_role_name
  generate_credentials_in_worker = false
  space_id                       = "root"
}