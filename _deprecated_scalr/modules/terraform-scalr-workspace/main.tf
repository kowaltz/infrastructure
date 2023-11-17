variable "branch" {
  type = string
}

variable "environment_id" {
  type = string
}

variable "name" {
  type = string
}

variable "repo" {
  type    = string
  default = "kowaltz/monorepo"
}

variable "list_of_provider_configurations" {
  type = list(map(string))
}

variable "modules_scalr_directory" {
  type    = string
  default = "infrastructure/modules/scalr"
}

variable "working_directory" {
  type = string
}

variable "vcs_provider_id" {
  type = string
}

resource "scalr_workspace" "workspace" {
  name            = var.name
  environment_id  = var.environment_id
  vcs_provider_id = var.vcs_provider_id

  working_directory = var.working_directory

  vcs_repo {
    identifier = var.repo
    branch     = var.branch
    trigger_prefixes = [
      var.working_directory,
      var.modules_scalr_directory
    ]
    dry_runs_enabled = true
  }

  dynamic "provider_configuration" {
    for_each = var.list_of_provider_configurations

    content {
      id = provider_configuration.value.id
      alias = provider_configuration.value.alias
    }
  }
}

output "id" {
  value = scalr_workspace.workspace.id
}