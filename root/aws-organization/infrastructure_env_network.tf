/*
module "aws_account_infrastructure_env_network" {
  for_each = var.set_of_environments
  source   = "../../modules/organizations-account"

  name              = "network"
  parent_id         = aws_organizations_organizational_unit.infrastructure_env[each.value].id
  path              = local.infrastructure_env_path[each.value]
  organization      = var.organization
  unique_identifier = local.unique_identifier
}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${module.aws_account_infrastructure_env_network["dev"].id}:role/OrganizationAccountAccessRole"
  }

  alias  = "infrastructure_dev_network"
  region = var.aws_region
}

resource "aws_iam_role" "infrastructure_dev_network-spacelift_default" {
  provider = aws.infrastructure_dev_vms

  name        = "${var.organization}-role-${local.infrastructure_env_path["dev"]}_network-spacelift_default"
  description = "Role for authenticating Spacelift with default methods, not OIDC, to ${local.infrastructure_env_path["dev"]}'s network account."
  assume_role_policy = templatefile("./policy_spacelift.json.tpl", {
    organization = var.organization
    env          = "dev"
    name         = "infrastructure_network"
  })
}

provider "aws" {
  alias  = "infrastructure_prod_network"
  region = var.aws_region

  assume_role {
    role_arn = "arn:aws:iam::${module.aws_account_infrastructure_env_network["prod"].id}:role/OrganizationAccountAccessRole"
  }
}

resource "aws_iam_role" "infrastructure_prod_network-spacelift_default" {
  provider = aws.infrastructure_prod_vms

  name        = "${var.organization}-role-${local.infrastructure_env_path["prod"]}_network-spacelift_default"
  description = "Role for authenticating Spacelift with default methods, not OIDC, to ${local.infrastructure_env_path["prod"]}'s network account."
  assume_role_policy = templatefile("./policy_spacelift.json.tpl", {
    organization = var.organization
    env          = "prod"
    name         = "infrastructure_network"
  })
}
*/