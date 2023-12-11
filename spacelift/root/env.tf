resource "spacelift_space" "env" {
  for_each = var.set_of_environments

  name             = "${var.organization}-space-${each.value}"
  parent_space_id  = "root"
  description      = "Space for managing ${each.value}-level Spacelift infrastructure."
  inherit_entities = true
}

resource "spacelift_stack" "env" {
  for_each = var.set_of_environments

  administrative       = true
  autodeploy           = false
  branch               = each.value
  description          = "Space for managing ${each.value}-level Spacelift infrastructure."
  enable_local_preview = true
  name                 = "${var.organization}-stack-${each.value}-spacelift"
  labels               = [spacelift_context.env[each.value].name]
  project_root         = "spacelift/env"
  repository           = var.repository
  space_id             = spacelift_space.env[each.value].id
  terraform_version    = var.terraform_version
}

resource "spacelift_stack_dependency" "env-on-aws_root_organization" {
  for_each = var.set_of_environments

  stack_id            = spacelift_stack.env[each.value].id
  depends_on_stack_id = spacelift_stack.cloud_root_organization["aws"].id
}

locals {
  context_env_name = { for env in var.set_of_environments :
    env => "${var.organization}-context-${env}"
  }
}

resource "spacelift_context" "env" {
  for_each = var.set_of_environments

  description = "Context with the ENV variable."
  name        = local.context_env_name[each.value]
  labels      = ["autoattach:${local.context_env_name[each.value]}"]
  space_id    = spacelift_space.env[each.value].id
}

resource "spacelift_environment_variable" "env" {
  for_each = var.set_of_environments

  context_id = spacelift_context.env[each.value].id
  name       = "TF_VAR_env"
  value      = each.value
  write_only = false
}

resource "spacelift_stack_dependency_reference" "infrastructure_env_vms_id" {
  for_each = var.set_of_environments

  stack_dependency_id = spacelift_stack_dependency.env-on-aws_root_organization[each.value].id
  output_name         = "aws_account_id_infrastructure_env_vms"
  input_name          = "TF_VAR_aws_account_id_infrastructure_env_vms"
}
