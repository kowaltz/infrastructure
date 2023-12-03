locals {
  space_short_id = split("-", var.space_id)[-1]

  role_arn = "arn:aws:iam::${var.account_id}:role/${var.organization}-role-${var.role_path}-spacelift_default"
}

resource "spacelift_aws_integration" "module" {
  name = "${var.organization}-cloud_integration-${local.space_short_id}-${var.stack_short_name}"

  role_arn                       = local.role_arn
  generate_credentials_in_worker = false
  space_id                       = var.space_id
}

resource "spacelift_aws_integration_attachment" "module" {
  integration_id = spacelift_aws_integration.module.id
  stack_id       = var.stack_id
  read           = var.read
  write          = var.write
}