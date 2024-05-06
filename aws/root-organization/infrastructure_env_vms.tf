locals {
  infrastructure_env_vms_path = {
    for env in var.set_of_environments: env => "root_infrastructure_${env}"
  }

  infrastructure_env_vms_assume_role_policy = {
    for env in var.set_of_environments: env => jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : [
              "324880187172"  # Spacelift's own AWS ID
            ]
          },
          "Action" : "sts:AssumeRole",
          "Condition" : {
            "StringLike" : {
              "sts:ExternalId" : [
                "${var.organization}-github@*@${var.organization}-stack-${env}-aws_infrastructure_vms@*",
                "${var.organization}-github@*@${var.organization}-stack-${env}-spacelift@*",
              ]
            }
          }
        }
      ]
    })
  }
}

module "aws_organizations_account" {
  for_each = var.set_of_environments
  source   = "../modules/organizations-account"

  name              = "vms"
  parent_id         = aws_organizations_organizational_unit.infrastructure-env[each.value].id
  path              = local.infrastructure_env_vms_path[each.value]
  organization      = var.organization
  unique_identifier = local.unique_identifier
}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${module.aws_organizations_account["dev"].id}:role/${var.organization}-vms"
  }

  alias  = "infrastructure_dev_vms"
  region = var.aws_region
}

resource "aws_iam_role" "infrastructure_dev_vms-spacelift_default" {
  provider    = aws.infrastructure_dev_vms
  
  name        = "${var.organization}-role-${local.infrastructure_env_vms_path["dev"]}_vms-spacelift_default"
  description = "Role for authenticating Spacelift with default methods, not OIDC, to ${local.infrastructure_env_vms_path["dev"]}'s vms account."
  assume_role_policy = local.infrastructure_env_vms_assume_role_policy["dev"]
}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${module.aws_organizations_account["prod"].id}:role/${var.organization}-vms"
  }

  alias  = "infrastructure_prod_vms"
  region = var.aws_region
}

resource "aws_iam_role" "infrastructure_prod_vms-spacelift_default" {
  provider    = aws.infrastructure_prod_vms
  
  name        = "${var.organization}-role-${local.infrastructure_env_vms_path["prod"]}_vms-spacelift_default"
  description = "Role for authenticating Spacelift with default methods, not OIDC, to ${local.infrastructure_env_vms_path["prod"]}'s vms account."
  assume_role_policy = local.infrastructure_env_vms_assume_role_policy["prod"]
}