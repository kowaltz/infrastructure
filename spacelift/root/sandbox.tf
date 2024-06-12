resource "spacelift_stack" "aws_sandbox" {
  administrative          = false
  autodeploy              = false
  branch                  = "dev"
  description             = "Space for AWS sandbox."
  enable_local_preview    = true
  labels                  = [local.context_root_aws_name]
  name                    = "${var.organization}-stack-root-aws_sandbox"
  project_root            = "aws/sandbox"
  repository              = var.repository
  space_id                = "root"
  terraform_version       = var.terraform_version
  terraform_workflow_tool = "OPEN_TOFU"
}

resource "spacelift_stack_dependency" "aws_sandbox-on-aws_root_organization" {
  stack_id            = spacelift_stack.aws_sandbox.id
  depends_on_stack_id = spacelift_stack.aws_root_organization.id
}

resource "spacelift_stack_dependency_reference" "aws_sandbox-on-aws_root_organization" {
  stack_dependency_id = spacelift_stack_dependency.aws_sandbox-on-aws_root_organization.id
  output_name         = "ou_sandbox_id"
  input_name          = "TF_VAR_ou_sandbox_id"
}