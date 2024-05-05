# This Terraform module is used to create an AWS Organizations account and associated resources.
# It generates an account name and email based on the provided variables, and creates an AWS Organizations account
# using the generated name and email. It also creates an IAM role for authenticating Spacelift with the account.
# The module outputs the ID and name of the created AWS Organizations account.

locals {
  account_name = substr("${var.organization}-account-${var.path}-${var.name}.${var.unique_identifier}",
    0,
    50  # AWS account names are limited to 50 characters.
  )
  account_email = "${local.account_name}@${var.organization}.com"
}

resource "aws_organizations_account" "module" {
  name              = local.account_name
  email             = local.account_email
  close_on_deletion = true
  parent_id         = var.parent_id
  role_name         = var.name
}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${module.aws_organizations_account["dev"]}:role/vms"
  }

  alias  = "organizations-account"
  region = var.aws_region
}

resource "aws_iam_role" "spacelift_default" {
  provider    = aws.provider_alias
  
  name        = "${var.organization}-role-${var.path}_${var.name}-spacelift_default"
  description = "Role for authenticating Spacelift with default methods, not OIDC, to ${var.path}'s ${var.name} account."

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
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
            "sts:ExternalId" : var.list_of_stack_permissions
          }
        }
      }
    ]
  })
}

output "id" {
  value = aws_organizations_account.module.id
}

output "name" {
  value = aws_organizations_account.module.name
}