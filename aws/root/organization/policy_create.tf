resource "aws_iam_policy_attachment" "create_organization" {
  name       = "create_organization"
  roles      = [var.root_role_name]
  policy_arn = aws_iam_policy.create_organization.arn
}

resource "aws_iam_policy" "create_organization" {
  name        = "${var.organization}-iam-policy-root-create_organization"
  path        = "/root/${var.organization}/"
  description = "Policy for creating an organization."

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "organizations:CreateOrganization"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}
