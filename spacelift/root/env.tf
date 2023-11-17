resource "spacelift_space" "env" {
  for_each = var.set_of_environments

  name = "${var.organization}-space-${each.value}"
  parent_space_id = "root"
  description = "Space for managing ${each.value}-level Spacelift infrastructure."
}

resource "spacelift_stack" "env" {
  for_each = var.set_of_environments

  administrative       = true
  autodeploy           = false
  branch               = each.value
  description          = "Space for managing ${each.value}-level Spacelift infrastructure."
  enable_local_preview = true
  name                 = "${var.organization}-stack-${each.value}-spacelift"
  project_root         = "spacelift/env"
  repository           = var.repository
  space_id             = each.value
  terraform_version    = var.terraform_version
}

resource "spacelift_stack_dependency" "env-on-root" {
  for_each = var.set_of_environments

  stack_id            = spacelift_stack.env[each.value].id
  depends_on_stack_id = data.spacelift_stack.root-spacelift.id
}

resource "spacelift_stack_dependency" "env-on-aws" {
  for_each = var.set_of_environments

  stack_id            = spacelift_stack.env[each.value].id
  depends_on_stack_id = spacelift_stack.cloud["aws"].id
}