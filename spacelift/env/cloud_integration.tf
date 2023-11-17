locals {
  aws_role_name = "arn:aws:iam::${var.aws_account_id}:role/${var.organization}-iam-role-${var.env}-spacelift_default"
}

resource "spacelift_aws_integration" "aws_env" {
  name = "${var.organization}-cloud_integration-${var.env}-aws_${var.env}"

  # We need to set the ARN manually rather than referencing the role to avoid a circular dependency
  role_arn                       = local.aws_role_name
  generate_credentials_in_worker = false
  space_id                       = var.env
}
