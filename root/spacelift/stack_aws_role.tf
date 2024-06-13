locals {
  context_root_aws_name     = "${var.organization}-context-root-aws"
  context_organization_name = "${var.organization}-context-organization"
}

resource "spacelift_stack" "root-aws_role" {
  administrative           = false
  autodeploy               = false
  branch                   = "prod"
  description              = "Space for managing the root role on AWS."
  enable_local_preview     = true
  labels = [
    local.context_root_aws_name,
    local.context_organization_name
  ]
  name                    = "${var.organization}-stack-root-aws_role"
  project_root            = "root/aws-role"
  repository              = var.repository
  space_id                = "root"
  terraform_version       = var.terraform_version
  terraform_workflow_tool = "OPEN_TOFU"
}

resource "spacelift_stack_dependency" "root_aws_role-on-root_spacelift" {
  stack_id            = spacelift_stack.root-aws_role.id
  depends_on_stack_id = data.spacelift_stack.root-spacelift.id
}

resource "spacelift_aws_integration_attachment" "root-aws_role" {
  integration_id = spacelift_aws_integration.root.id
  stack_id       = spacelift_stack.root-aws_role.id
  read           = true
  write          = true
}