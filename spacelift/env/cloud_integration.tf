locals {
  aws_role_name = "arn:aws:iam::${var.aws_account_id}:role/${var.organization}-iam-role-${var.env}-spacelift_default"
}

resource "spacelift_aws_integration" "aws_env" {
  name = "${var.organization}-cloud_integration-${var.env}-aws_${var.env}"

  role_arn                       = local.aws_role_name
  generate_credentials_in_worker = false
  space_id                       = var.env
}

resource "spacelift_aws_integration_attachment" "aws_env-to-aws_infrastructure_vms" {
  integration_id = spacelift_aws_integration.aws_env.id
  stack_id       = spacelift_stack.env-aws_infrastructure_vms.id
  read           = true
  write          = true
}