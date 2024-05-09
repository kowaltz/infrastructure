resource "spacelift_stack" "sandbox_aws" {
  administrative          = false
  autodeploy              = false
  branch                  = "dev"
  description             = "Space for AWS sandbox."
  enable_local_preview    = true
  labels                  = [local.context_root_cloud_name["aws"]]
  name                    = "${var.organization}-stack-root-aws_sandbox"
  project_root            = "aws/sandbox"
  repository              = var.repository
  space_id                = "root"
  terraform_version       = var.terraform_version
  terraform_workflow_tool = "OPEN_TOFU"
}