resource "aws_iam_policy_attachment" "iam_manage" {
  name       = "iam_manage"
  roles      = [local.root_role_name]
  policy_arn = aws_iam_policy.iam_manage.arn
}

resource "aws_iam_policy" "iam_manage" {
  name        = "${local.organization}-policy-root-iam_manage"
  path        = "/root/${local.organization}/"
  description = "Policy for managing IAM roles and policies."

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:ListAttachedRolePolicies",
          "iam:ListInstanceProfilesForRole",
          "iam:ListRolePolicies",
          "iam:ListRoles",
          "iam:ListRoleTags",
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:UpdateRole",
          "iam:UpdateRoleDescription",
          "iam:UpdateAssumeRolePolicy",
          "iam:AttachRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:DetachRolePolicy",
          "iam:DeleteRolePermissionsBoundary",
          "iam:PutRolePermissionsBoundary",
          "iam:PutRolePolicy",
        ],
        "Resource" : [
          "arn:aws:iam::${var.aws_account_id}:role/${local.organization}-*"
        ]
      }
    ]
  })
}
