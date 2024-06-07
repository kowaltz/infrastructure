resource "aws_iam_policy_attachment" "org_create" {
  name       = "org_create"
  roles      = [local.root_role_name]
  policy_arn = aws_iam_policy.org_create.arn
}

resource "aws_iam_policy" "org_create" {
  name        = "${var.organization}-iam-policy-root-org_create"
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
