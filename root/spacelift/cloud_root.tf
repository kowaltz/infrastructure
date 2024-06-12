locals {
  context_root_aws_name = "${var.organization}-context-root-aws"
  context_organization_name = "${var.organization}-context-organization"
}

resource "spacelift_stack" "root-aws_role" {
  administrative          = false
  autodeploy              = false
  branch                  = "prod"
  description             = "Space for managing the root role on AWS."
  enable_local_preview    = true
  labels                  = [
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

resource "spacelift_stack" "root-aws_organization" {
  administrative          = false
  autodeploy              = false
  branch                  = "prod"
  description             = "Space for managing root-level AWS infrastructure."
  enable_local_preview    = true
  labels                  = [
    local.context_root_aws_name,
    local.context_organization_name
  ]
  name                    = "${var.organization}-stack-root-aws_organization"
  project_root            = "root/aws-organization"
  repository              = var.repository
  space_id                = "root"
  terraform_version       = var.terraform_version
  terraform_workflow_tool = "OPEN_TOFU"
}

resource "spacelift_stack" "root-aws_integrations" {
  administrative          = false
  autodeploy              = false
  branch                  = "prod"
  description             = "Space for managing root-level integrations to AWS."
  enable_local_preview    = true
  labels                  = [
    local.context_root_aws_name,
    local.context_organization_name
  ]
  name                    = "${var.organization}-stack-root-aws_integrations"
  project_root            = "root/aws-integrations"
  repository              = var.repository
  space_id                = "root"
  terraform_version       = var.terraform_version
  terraform_workflow_tool = "OPEN_TOFU"
}

resource "spacelift_stack_dependency" "root_aws_role-on-root_spacelift" {
  stack_id            = spacelift_stack.root-aws_role.id
  depends_on_stack_id = data.spacelift_stack.root-spacelift.id
}

resource "spacelift_stack_dependency" "root_aws_organization-on-root_aws_role" {
  stack_id            = spacelift_stack.root-aws_organization.id
  depends_on_stack_id = spacelift_stack.root-aws_role.id
}

resource "spacelift_stack_dependency" "root_aws_integrations-on-root_aws_organization" {
  stack_id            = spacelift_stack.root-aws_integrations.id
  depends_on_stack_id = spacelift_stack.root-aws_organization.id
}

resource "spacelift_stack_dependency_reference" "root_aws_organization-on-root_aws_role" {
  stack_dependency_id = spacelift_stack_dependency.root_aws_organization-on-root_aws_role.id
  output_name         = "root_role_name"
  input_name          = "TF_VAR_root_role_name"
}