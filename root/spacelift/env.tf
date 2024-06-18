locals {
  architecture = yamldecode(file(var.path_architecture_yaml))
}

resource "spacelift_space" "env" {
  for_each = local.architecture.environments

  name             = "${var.organization}-space-${each.value}"
  parent_space_id  = "root"
  description      = "Space for managing ${each.value}-level Spacelift infrastructure."
  inherit_entities = true
}

locals {
  context_env_name = { for env in local.architecture.environments :
    env => "${var.organization}-context-${env}"
  }
}

resource "spacelift_context" "env" {
  for_each = local.architecture.environments

  description = "Context with ENV-specific variables."
  name        = local.context_env_name[each.value]
  labels      = ["autoattach:${local.context_env_name[each.value]}"]
  space_id    = spacelift_space.env[each.value].id
}

resource "spacelift_environment_variable" "env" {
  for_each = local.architecture.environments

  context_id = spacelift_context.env[each.value].id
  name       = "TF_VAR_env"
  value      = each.value
  write_only = false
}