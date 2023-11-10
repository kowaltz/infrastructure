resource "aws_iam_policy_attachment" "read" {
  name       = "AWSOrganizationsReadOnlyAccess"
  roles      = [local.root_role_name]
  policy_arn = "arn:aws:iam::aws:policy/AWSOrganizationsReadOnlyAccess"
}

resource "aws_iam_policy_attachment" "organization_manage" {
  name       = "organization_manage"
  roles      = [local.root_role_name]
  policy_arn = aws_iam_policy.organization_manage.arn
}

resource "aws_iam_policy" "organization_manage" {
  name        = "${var.organization}-iam-policy-root-organization_manage"
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
          "arn:aws:organizations::${var.aws_account_id}:*/${local.org_id}/*"
        ]
      }
    ]
  })
}
