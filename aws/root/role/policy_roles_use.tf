resource "aws_iam_policy_attachment" "roles_use" {
  name       = "roles_use"
  roles      = [local.root_role_name]
  policy_arn = aws_iam_policy.roles_use.arn
}

resource "aws_iam_policy" "roles_use" {
  name        = "${var.organization}-iam-policy-root-roles_use"
  path        = "/root/${var.organization}/"
  description = "Policy for being able to assume or pass IAM and STS roles in any account in the organization."

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:PassRole",
          "sts:AssumeRole"
        ],
        "Resource" : [
          "arn:aws:iam::*:role/${var.organization}-*",
          "arn:aws:iam::*:role/AWS*"
        ]
      }
    ]
  })
}