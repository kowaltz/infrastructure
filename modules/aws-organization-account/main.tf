# This Terraform module is used to create an AWS Organizations account and associated resources.
# It generates an account name and email based on the provided variables, and creates an AWS Organizations account
# using the generated name and email.
# The module outputs the ID and name of the created AWS Organizations account.

locals {
  account_name = substr("${var.organization}-account-${var.path}-${var.account_name}:${var.unique_identifier}",
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
}