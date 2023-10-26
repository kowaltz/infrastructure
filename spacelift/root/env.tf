resource "spacelift_stack" "env" {
  for_each = var.set_of_environments

  administrative       = true
  autodeploy           = false
  branch               = each.value
  description          = "Space for managing ${each.value}-level Spacelift infrastructure."
  enable_local_preview = true
  name                 = "${var.organization}-stack-root-${each.value}"
  project_root         = "${var.directory}/spacelift/env"
  repository           = var.repository
  space_id             = "root"
  terraform_version    = var.terraform_version
}

resource "spacelift_stack_dependency" "env" {
  for_each = var.set_of_environments

  stack_id            = spacelift_stack.env[each.value].id
  depends_on_stack_id = data.spacelift_stack.root-spacelift.id
}