resource "aws_cloudformation_stack_set" "role_spacelift_default" {
  // This resource creates the Stack Set for the IAM role, auto-deployable at the OU level.
  name = "${var.organization}-stackset-${var.path}-role_spacelift_default"

  permission_model = "SERVICE_MANAGED"
  
  auto_deployment {
    enabled = true
    retain_stacks_on_account_removal = false
  }

  template_body = templatefile("${path.module}/iam_role.yaml.tpl", {
    organization = var.organization
    space_id = var.space_id
    name = var.account_name
  })

  capabilities = [
    "CAPABILITY_NAMED_IAM"
  ]
}

resource "aws_cloudformation_stack_set_instance" "role_spacelift_default" {
  // This resource specifies the target of the Stack Set.
  deployment_targets {
    organizational_unit_ids = [var.ou_id]
  }
  stack_set_name = aws_cloudformation_stack_set.role_spacelift_default.name
  region = var.aws_region
}

resource "spacelift_aws_integration" "path-account" {
  name = "${var.organization}-aws_integration-${var.path}-${var.account_name}"

  # We need to set the ARN manually rather than referencing the role to avoid a circular dependency
  role_arn                       = "arn:aws:iam::${var.account_id}:role/${var.organization}-iam-role-${var.path}_${var.account_name}-spacelift_default"
  generate_credentials_in_worker = false
  space_id                       = var.space_id
}