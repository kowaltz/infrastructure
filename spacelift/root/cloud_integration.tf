locals {
  aws_role_name = "arn:aws:iam::${var.aws_account_id}:role/${var.organization}-iam-role-root-spacelift_default"
}

resource "spacelift_aws_integration" "aws_root" {
  name = "${var.organization}-cloud_integration-root-aws_root"

  # We need to set the ARN manually rather than referencing the role to avoid a circular dependency
  role_arn                       = local.aws_role_name
  generate_credentials_in_worker = false
  space_id                       = "root"
}

resource "spacelift_aws_integration_attachment" "aws_root_attachment" {
  integration_id = spacelift_aws_integration.aws_root.id
  stack_id       = spacelift_stack.cloud["aws"].id
  read           = true
  write          = true
}