resource "spacelift_stack" "cloud" {
  for_each = var.set_of_clouds

  administrative    = true
  autodeploy        = false
  branch            = "prod"
  description       = "Space for managing root-level ${each.value} infrastructure."
  enable_local_preview = true
  name              = "${var.organization}-stack-root-${each.value}"
  project_root      = "infrastructure/${each.value}/root"
  repository        = var.repository
  space_id          = "root"
  terraform_version    = var.terraform_version
}

resource "spacelift_stack_dependency" "cloud" {
  for_each = var.set_of_clouds

  stack_id            = spacelift_stack.cloud[each.value].id
  depends_on_stack_id = data.spacelift_stack.root-spacelift.id
}

resource "spacelift_context_attachment" "cloud" {
  for_each = var.set_of_clouds
  context_id = "${var.organization}-${each.value}"
  stack_id   = spacelift_stack.cloud[each.value].id
  priority   = 0
}