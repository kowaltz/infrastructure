locals {
  map_of_environments_and_providers = {
    "dev" = aws.dev
    "prod" = aws.prod
  }
}

module "aws_organizations_account" {
  for_each = var.set_of_environments
  source   = "../modules/organizations-account"

  #provider_to_assume = map_of_environments_and_providers[each.value]
  
  list_of_stack_permissions = [
    "${var.organization}-github@*@${var.organization}-stack-${each.value}-aws_infrastructure_vms@*",
    "${var.organization}-github@*@${var.organization}-stack-${each.value}-spacelift@*",
  ]
  name              = "vms"
  parent_id         = aws_organizations_organizational_unit.infrastructure-env[each.value].id
  path              = "root_infrastructure_${each.value}"
  organization      = var.organization
  unique_identifier = local.unique_identifier
}