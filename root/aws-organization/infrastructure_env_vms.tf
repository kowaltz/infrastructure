/*
module "aws_account_infrastructure_env_vms" {
  for_each = var.set_of_environments
  source   = "../../modules/organizations-account"

  name              = "vms"
  parent_id         = aws_organizations_organizational_unit.infrastructure_env[each.value].id
  path              = local.infrastructure_env_path[each.value]
  organization      = var.organization
  unique_identifier = local.unique_identifier
}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${module.aws_account_infrastructure_env_vms["dev"].id}:role/OrganizationAccountAccessRole"
  }

  alias  = "infrastructure_dev_vms"
  region = var.aws_region
}

resource "aws_iam_role" "infrastructure_dev_vms-spacelift_default" {
  provider = aws.infrastructure_dev_vms

  name        = "${var.organization}-role-${local.infrastructure_env_path["dev"]}_vms-spacelift_default"
  description = "Role for authenticating Spacelift with default methods, not OIDC, to ${local.infrastructure_env_path["dev"]}'s vms account."
  assume_role_policy = templatefile("./policy_spacelift.json.tpl", {
    organization = var.organization
    env          = "dev"
    name         = "infrastructure_vms"
  })
}

provider "aws" {
  alias  = "infrastructure_prod_vms"
  region = var.aws_region

  assume_role {
    role_arn = "arn:aws:iam::${module.aws_account_infrastructure_env_vms["prod"].id}:role/OrganizationAccountAccessRole"
  }
}

resource "aws_iam_role" "infrastructure_prod_vms-spacelift_default" {
  provider = aws.infrastructure_prod_vms

  name        = "${var.organization}-role-${local.infrastructure_env_path["prod"]}_vms-spacelift_default"
  description = "Role for authenticating Spacelift with default methods, not OIDC, to ${local.infrastructure_env_path["prod"]}'s vms account."
  assume_role_policy = templatefile("./policy_spacelift.json.tpl", {
    organization = var.organization
    env          = "prod"
    name         = "infrastructure_vms"
  })
}
*/

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
/*
resource "aws_organizations_account" "env-vms" {
  for_each          = var.set_of_environments
  name              = "${var.organization}-account-root_infrastructure_${each.value}-vms"
  email             = "account-root_infrastructure_${each.value}-vms@${var.organization}.com"
  close_on_deletion = true
  parent_id         = aws_organizations_organizational_unit.infrastructure-env[each.value].id
}

module "oidc_provider-github-workloads" {
  depends_on = [ aws_iam_openid_connect_provider.github_actions ]
  for_each = var.set_of_environments
  source = "../modules/oidc_provider-github"

  aws_account_id = aws_organizations_account.env-vms[each.value].id
  env = each.value
  github_repo = "monorepo"
}
*/