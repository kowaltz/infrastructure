locals {
  context_root_aws_name = "${var.organization}-context-root-aws"
}

resource "spacelift_stack" "aws_root_role" {
  administrative          = false
  autodeploy              = false
  branch                  = "prod"
  description             = "Space for managing the root role on AWS."
  enable_local_preview    = true
  labels                  = [local.context_root_aws_name]
  name                    = "${var.organization}-stack-root-aws_root_role"
  project_root            = "aws/root/role"
  repository              = var.repository
  space_id                = "root"
  terraform_version       = var.terraform_version
  terraform_workflow_tool = "OPEN_TOFU"
}

resource "spacelift_stack" "aws_root_organization" {
  administrative          = false
  autodeploy              = false
  branch                  = "prod"
  description             = "Space for managing root-level AWS infrastructure."
  enable_local_preview    = true
  labels                  = [local.context_root_aws_name]
  name                    = "${var.organization}-stack-root-aws_root_organization"
  project_root            = "aws/root/organization"
  repository              = var.repository
  space_id                = "root"
  terraform_version       = var.terraform_version
  terraform_workflow_tool = "OPEN_TOFU"
}

resource "spacelift_stack" "aws_root_integrations" {
  administrative          = false
  autodeploy              = false
  branch                  = "prod"
  description             = "Space for managing root-level integrations to AWS."
  enable_local_preview    = true
  labels                  = [local.context_root_aws_name]
  name                    = "${var.organization}-stack-root-aws_root_integrations"
  project_root            = "aws/root/integrations"
  repository              = var.repository
  space_id                = "root"
  terraform_version       = var.terraform_version
  terraform_workflow_tool = "OPEN_TOFU"
}

resource "spacelift_stack_dependency" "aws_root_role-on-root" {
  stack_id            = spacelift_stack.aws_root_role.id
  depends_on_stack_id = data.spacelift_stack.root-spacelift.id
}

resource "spacelift_stack_dependency" "aws_root_organization-on-aws_root_role" {
  stack_id            = spacelift_stack.aws_root_organization.id
  depends_on_stack_id = spacelift_stack.aws_root_role.id
}

resource "spacelift_stack_dependency" "aws_root_integrations-on-aws_root_organization" {
  stack_id            = spacelift_stack.aws_root_integrations.id
  depends_on_stack_id = spacelift_stack.aws_root_organization.id
}

resource "spacelift_stack_dependency_reference" "aws_root_organization-on-aws_root_role" {
  stack_dependency_id = spacelift_stack_dependency.aws_root_organization-on-aws_root_role.id
  output_name         = "root_role_name"
  input_name          = "TF_VAR_root_role_name"
}