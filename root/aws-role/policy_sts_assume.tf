resource "aws_iam_policy_attachment" "sts_assume" {
  name       = "sts_assume"
  roles      = [local.root_role_name]
  policy_arn = aws_iam_policy.sts_assume.arn
}

resource "aws_iam_policy" "sts_assume" {
  name        = "${local.organization}-policy-root-sts_assume"
  path        = "/root/${local.organization}/"
  description = "Policy for being able to assume STS roles in any account in the organization."

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Resource" : [
          "arn:aws:iam::*:role/${local.organization}-*",
          "arn:aws:iam::*:role/OrganizationAccountAccessRole"
        ]
      }
    ]
  })
}