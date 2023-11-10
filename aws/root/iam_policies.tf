resource "aws_iam_policy_attachment" "read" {
  name       = "AWSOrganizationsReadOnlyAccess"
  roles      = [local.root_role_name]
  policy_arn = aws_iam_policy.read.arn
}

resource "aws_iam_policy_attachment" "ou_create_org" {
  name       = "ou_create_org"
  roles      = [local.root_role_name]
  policy_arn = aws_iam_policy.ou_create_org.arn
}

resource "aws_iam_policy" "ou_create_org" {
  name        = "${var.organization}-iam-policy-root-ou_create_org"
  path        = "/root/"
  description = "Policy for creating the org's OU at the root level."

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "organizations:CreateOrganizationalUnit",
          "organizations:DeleteOrganizationalUnit"
        ],
        "Resource" : [
          "arn:aws:organizations::${var.aws_account_id}:root/${local.org_id}/${local.org_root_id}",
          "*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "organizations_manage" {
  name       = "organizations_manage"
  roles      = [local.root_role_name]
  policy_arn = aws_iam_policy.manage_organization.arn
}

resource "aws_iam_policy" "manage_organization" {
  name        = "${var.organization}-iam-policy-root-organizations_manage"
  path        = "/root/"
  description = "Policy for managing an organization, OUs and their accounts at the root level. It also allows the role to manage policies at the organizational level."

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "organizations:ListAccounts",
          "organizations:ListChildren",
          "organizations:ListCreateAccountStatus",
          "organizations:ListAccountsForParent",
          "organizations:ListOrganizationalUnitsForParent",
          "organizations:ListParents",
          "organizations:ListPolicies",
          "organizations:ListPoliciesForTarget",
          "organizations:ListTargetsForPolicy",
          "organizations:DescribeCreateAccountStatus",
          "organizations:DescribeEffectivePolicy",
          "organizations:DescribeOrganizationalUnit",
          "organizations:DescribePolicy",
          "organizations:AttachPolicy",
          "organizations:CloseAccount",
          "organizations:CreateAccount",
          "organizations:CreatePolicy",
          "organizations:CreateOrganizationalUnit",
          "organizations:DeleteOrganizationalUnit",
          "organizations:DeletePolicy",
          "organizations:DetachPolicy",
          "organizations:DisablePolicyType",
          "organizations:EnablePolicyType",
          "organizations:InviteAccountToOrganization",
          "organizations:MoveAccount",
          "organizations:RemoveAccountFromOrganization",
          "organizations:UpdateOrganizationalUnit",
          "organizations:UpdatePolicy"
        ],
        "Resource" : [
          "arn:aws:organizations::${var.aws_account_id}:ou/${local.org_id}/ou-*",
          "arn:aws:organizations::${var.aws_account_id}:account/${local.org_id}/*",
          "arn:aws:organizations::${var.aws_account_id}:policy/${local.org_id}/*/p-*"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:ResourceOrgPaths" : [
              "${local.org_id}/${local.org_root_id}/${local.org_id}/*"
            ]
          }
        }
      }
    ]
  })
}