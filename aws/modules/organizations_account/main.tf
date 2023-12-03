locals {
  account_name = substr("${var.organization}-account-${var.path}-${var.name}.${var.unique_identifier}",
    0,
    50
  )
  account_email = "${local.account_name}@${var.organization}.com"
}

resource "aws_organizations_account" "module" {
  name              = local.account_name
  email             = local.account_email
  close_on_deletion = true
  parent_id         = var.parent_id
}

resource "aws_iam_role" "infrastructure_env_vms-spacelift_default" {
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
            var.root_account_id,
            "${aws_organizations_account.module.id}"
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