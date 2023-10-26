locals {
  working_directory = "${var.path_scalr_dir}/env"
}

module "scalr-workspace-env" {
  source = "../../../../modules/scalr/terraform-scalr-workspace"

  branch         = var.env
  environment_id = var.scalr_environment_id
  name           = "scalr-workspace-${var.env}"
  list_of_provider_configurations = concat(
    [{
      id    = module.providers-scalr_env.id
      alias = module.providers-scalr_env.name
    }],
    var.list_of_provider_configurations
  )
  vcs_provider_id   = var.vcs_provider_id
  working_directory = local.working_directory
}

resource "scalr_variable" "env" {
  account_id   = var.account_id
  key          = "env"
  value        = var.env
  category     = "terraform"
  description  = "Environment short-form denominator"
  workspace_id = module.scalr-workspace-env.id
}