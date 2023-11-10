resource "aws_iam_policy_attachment" "read" {
  name       = "AWSOrganizationsReadOnlyAccess"
  roles      = [local.root_role_name]
  policy_arn = "arn:aws:iam::aws:policy/AWSOrganizationsReadOnlyAccess"
}

resource "aws_iam_policy_attachment" "ou_manage" {
  name       = "ou_manage"
  roles      = [local.root_role_name]
  policy_arn = aws_iam_policy.ou_manage.arn
}

resource "aws_iam_policy" "ou_manage" {
  name        = "${var.organization}-iam-policy-root-ou_manage"
  path        = "/root/${var.organization}/"
  description = "Policy for basic management of OUs."

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "organizations:CreateOrganizationalUnit"
        ],
        "Resource" : [
          "arn:aws:organizations::${var.aws_account_id}:*/${local.org_id}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "organizations_manage" {
  name       = "organizations_manage"
  roles      = [local.root_role_name]
  policy_arn = aws_iam_policy.organizations_manage.arn
}

resource "aws_iam_policy" "organizations_manage" {
  name        = "${var.organization}-iam-policy-root-organizations_manage"
  path        = "/root/${var.organization}/"
  description = "Policy for managing an organization, OUs and their accounts at the organization's root level. It also allows the role to manage policies at the organizational level."

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "organizations:AttachPolicy",
          "organizations:CloseAccount",
          "organizations:Create*",
          "organizations:Delete*",
          "organizations:DetachPolicy",
          "organizations:DisablePolicyType",
          "organizations:EnablePolicyType",
          "organizations:MoveAccount",
          "organizations:RemoveAccountFromOrganization",
          "organizations:Update*"
        ],
        "Resource" : [
          "arn:aws:organizations::${var.aws_account_id}:ou/${local.org_id}/ou-*",
          "arn:aws:organizations::${var.aws_account_id}:account/${local.org_id}/*",
          "arn:aws:organizations::${var.aws_account_id}:policy/${local.org_id}/*/p-*"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:ResourceOrgPaths" : [
              "${local.org_id}/${local.org_root_id}/${local.org_id}/${aws_organizations_organizational_unit.org_root.id}/*"
            ]
          }
        }
      }
    ]
  })
}