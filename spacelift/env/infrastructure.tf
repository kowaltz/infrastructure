locals {
  stack_short_name = "aws_infrastructure_vms"
}

resource "spacelift_stack" "env-aws_infrastructure_vms" {
  administrative       = false
  autodeploy           = true
  branch               = var.env
  description          = "Space for managing VMs in ${var.env}."
  enable_local_preview = true
  name                 = "${var.organization}-stack-${var.env}-${local.stack_short_name}"
  project_root         = "aws/infrastructure/env-vms"
  repository           = var.repository
  space_id             = data.spacelift_stack.env-spacelift.space_id
  terraform_version    = var.terraform_version
}

resource "spacelift_stack_dependency" "aws_infrastructure_vms-on-env" {
  stack_id            = spacelift_stack.env-aws_infrastructure_vms.id
  depends_on_stack_id = data.spacelift_stack.env-spacelift.id
}

module "aws-integration-default-infrastructure_env_vms" {
  source = "../modules/aws-integration-default"

  account_id       = var.aws_account_id
  organization     = var.organization
  role_path        = "root_infrastructure_${var.env}_vms"
  stack_id         = spacelift_stack.env-aws_infrastructure_vms.id
  stack_short_name = local.stack_short_name
  space_id         = data.spacelift_stack.env-spacelift.space_id
  space_short_id   = var.env
  write            = true
}