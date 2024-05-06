resource "aws_iam_policy_attachment" "assume_role" {
  name       = "assume_role"
  roles      = [local.root_role_name]
  policy_arn = aws_iam_policy.assume_role.arn
}

resource "aws_iam_policy" "assume_role" {
  name        = "${var.organization}-iam-policy-root-assume_role"
  path        = "/root/${var.organization}/"
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
          "arn:aws:iam::*:role/${var.organization}-*"
        ]
      }
    ]
  })
}