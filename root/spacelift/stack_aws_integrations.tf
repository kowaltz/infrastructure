resource "spacelift_stack" "root-aws_integrations" {
  administrative       = false
  autodeploy           = false
  branch               = "prod"
  description          = "Space for managing root-level integrations to AWS."
  enable_local_preview = true
  labels = [
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

resource "spacelift_stack_dependency" "root_aws_integrations-on-root_aws_organization" {
  stack_id            = spacelift_stack.root-aws_integrations.id
  depends_on_stack_id = spacelift_stack.root-aws_organization.id
}

resource "spacelift_aws_integration_attachment" "root-aws_integrations" {
  integration_id = spacelift_aws_integration.root.id
  stack_id       = spacelift_stack.root-aws_integrations.id
  read           = true
  write          = true
}