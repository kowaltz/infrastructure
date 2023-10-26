# Root environment
resource "scalr_environment" "root" {
  name                            = "account-environment-root"
  account_id                      = var.account_id
  cost_estimation_enabled         = true
  policy_groups                   = []
  default_provider_configurations = []
}

module "providers-cloud_root" {
  source = "../../modules/scalr/providers/terraform-scalr-cloud_env"

  account_id        = var.account_id
  aws_audience      = "root-idp-oidc_scalr"
  aws_role_arn      = var.aws_root_role_scalr_arn
  azure_audience    = "root-application-oidc_scalr"
  azure_credentials = local.azure_root_credentials
  env               = "root"
  list_of_shared_environments_ids = [
    scalr_environment.root.id,
    scalr_environment.scalr.id
  ]
  set_of_cloud_providers = local.set_of_cloud_providers
}

# Workspaces in "root" environment for initializing root-level resources in cloud providers
module "root-workspace-cloud" {
  for_each = local.set_of_cloud_providers
  source   = "../../modules/scalr/terraform-scalr-workspace"

  branch         = "prod"
  environment_id = scalr_environment.root.id
  name           = "root-workspace-${each.key}"
  list_of_provider_configurations = [{
    id    = module.providers-cloud_root.ids[each.key]
    alias = module.providers-cloud_root.names[each.key]
  }]
  vcs_provider_id   = local.vcs_provider_id
  working_directory = "infrastructure/${each.key}/root"
}
