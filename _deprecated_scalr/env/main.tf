provider "scalr" {
  hostname = var.hostname
  token    = var.api_token
}


# VCS Provider
data "scalr_vcs_provider" "github" {
  name       = "Kowaltz"
  account_id = var.account_id
  vcs_type   = "github"
}

locals {
  set_of_cloud_providers = toset(["aws", "azure"])

  vcs_provider_id = data.scalr_vcs_provider.github.id
}

data "scalr_environment" "env" {
  name       = "account-environment-${var.env}"
  account_id = var.account_id
}

/*
# Example: Add a piece of infrastructure
module "example" {
    source = "../../modules/workspace"

    branch = var.env
    environment_id = var.environment_id
    name = "${var.env}-workspace-example"
    provider_id = module.providers-cloud_env.ids["aws"]  # This workspace is for an AWS run
    vcs_provider_id = local.vcs_provider_id
    working_directory = "vault/infrastructure"
}
*/