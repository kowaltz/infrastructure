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

resource "spacelift_aws_integration_attachment" "root-aws_role" {
  integration_id = spacelift_aws_integration.root.id
  stack_id       = spacelift_stack.root-aws_role.id
  read           = true
  write          = true
}

resource "spacelift_aws_integration_attachment" "root-aws_organization" {
  integration_id = spacelift_aws_integration.root.id
  stack_id       = spacelift_stack.root-aws_organization.id
  read           = true
  write          = true
}

resource "spacelift_aws_integration_attachment" "root-aws_integrations" {
  integration_id = spacelift_aws_integration.root.id
  stack_id       = spacelift_stack.root-aws_integrations.id
  read           = true
  write          = true
}