resource "spacelift_stack" "root-aws_architecture" {
  additional_project_globs = ["architecture.yaml"]
  administrative       = false
  autodeploy           = false
  branch               = "prod"
  description          = "Space for managing root-level AWS infrastructure."
  enable_local_preview = true
  labels = [
    local.context_root_aws,
    local.context_organization
  ]
  name                    = "${var.organization}-stack-root-aws_architecture"
  project_root            = "root/aws-architecture"
  repository              = var.repository
  space_id                = "root"
  terraform_version       = var.terraform_version
  terraform_workflow_tool = "OPEN_TOFU"
}

resource "spacelift_stack_dependency" "root_aws_architecture-on-root_aws_role" {
  stack_id            = spacelift_stack.root-aws_architecture.id
  depends_on_stack_id = spacelift_stack.root-aws_role.id
}

resource "spacelift_stack_dependency_reference" "root_aws_architecture-on-root_aws_role" {
  stack_dependency_id = spacelift_stack_dependency.root_aws_architecture-on-root_aws_role.id
  output_name         = "root_role_name"
  input_name          = "TF_VAR_root_role_name"
}

resource "spacelift_aws_integration_attachment" "root-aws_architecture" {
  integration_id = spacelift_aws_integration.root.id
  stack_id       = spacelift_stack.root-aws_architecture.id
  read           = true
  write          = true
}