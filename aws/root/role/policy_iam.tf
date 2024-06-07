resource "aws_iam_policy_attachment" "manage_roles" {
  name       = "manage_roles"
  roles      = [local.root_role_name]
  policy_arn = aws_iam_policy.manage_roles.arn
}

resource "aws_iam_policy" "manage_roles" {
  name        = "${var.organization}-iam-policy-root-manage_roles"
  path        = "/root/${var.organization}/"
  description = "Policy for managing IAM roles."

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
          "iam:PassRole",
          "iam:PutRolePermissionsBoundary",
          "iam:PutRolePolicy",
        ],
        "Resource" : [
          "arn:aws:iam::${var.aws_account_id}:role/*"
        ]
      }
    ]
  })
}
