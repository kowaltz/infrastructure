locals {
  context_root_cloud_name = { for cloud in var.set_of_clouds :
    cloud => "${var.organization}-context-root-${cloud}"
  }
}

resource "spacelift_stack" "cloud_root_role" {
  for_each = var.set_of_clouds

  administrative       = false
  autodeploy           = false
  branch               = "prod"
  description          = "Space for managing the root role on ${each.value}."
  enable_local_preview = true
  labels               = [local.context_root_cloud_name[each.value]]
  name                 = "${var.organization}-stack-root-${each.value}_root_role"
  project_root         = "${each.value}/root-role"
  repository           = var.repository
  space_id             = "root"
  terraform_version    = var.terraform_version
}

resource "spacelift_stack" "cloud_root_organization" {
  for_each = var.set_of_clouds

  administrative       = false
  autodeploy           = false
  branch               = "prod"
  description          = "Space for managing root-level ${each.value} infrastructure."
  enable_local_preview = true
  labels               = [local.context_root_cloud_name[each.value]]
  name                 = "${var.organization}-stack-root-${each.value}_root_organization"
  project_root         = "${each.value}/root-organization"
  repository           = var.repository
  space_id             = "root"
  terraform_version    = var.terraform_version
}

resource "spacelift_stack_dependency" "cloud_root_role-on-root" {
  for_each = var.set_of_clouds

  stack_id            = spacelift_stack.cloud_root_role[each.value].id
  depends_on_stack_id = data.spacelift_stack.root-spacelift.id
}

resource "spacelift_stack_dependency" "cloud_root_organization-on-cloud_root_role" {
  for_each = var.set_of_clouds

  stack_id            = spacelift_stack.cloud_root_organization[each.value].id
  depends_on_stack_id = spacelift_stack.cloud_root_role[each.value].id
}

resource "spacelift_stack_dependency_reference" "cloud_root_organization-on-cloud_root_role" {
  for_each = var.set_of_clouds

  stack_dependency_id = spacelift_stack_dependency.cloud_root_organization-on-cloud_root_role[each.value].id
  output_name         = "root_role_name"
  input_name          = "TF_VAR_root_role_name"
}