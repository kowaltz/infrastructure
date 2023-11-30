resource "spacelift_stack" "env-aws_infrastructure_vms" {
  administrative       = false
  autodeploy           = true
  branch               = var.env
  description          = "Space for managing ${var.env}-level Spacelift infrastructure."
  enable_local_preview = true
  name                 = "${var.organization}-stack-${var.env}-aws_infrastructure_vms"
  project_root         = "aws/infrastructure/env-vms"
  repository           = var.repository
  space_id             = data.spacelift_stack.env-spacelift.space_id
  terraform_version    = var.terraform_version
}

resource "spacelift_stack_dependency" "aws_infrastructure_vms-on-env" {
  stack_id            = spacelift_stack.env-aws_infrastructure_vms.id
  depends_on_stack_id = data.spacelift_stack.env-spacelift.id
}
