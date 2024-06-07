resource "aws_iam_policy_attachment" "cloudformation" {
  name       = "cloudformation"
  roles      = [local.root_role_name]
  policy_arn = aws_iam_policy.cloudformation.arn
}

resource "aws_iam_policy" "cloudformation" {
  name        = "${var.organization}-iam-policy-root-cloudformation"
  path        = "/root/${var.organization}/"
  description = "Policies for using AWS CloudFormation."

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PassRole"
        "Effect" : "Allow",
        "Action" : [
          "iam:PassRole"
        ],
        "Resource" : [
          "arn:aws:iam::${var.aws_account_id}:role/AWSCloudFormationStackSetAdministrationRole"
        ]
      },
      {
        "Sid" : "CreateStackSet"
        "Effect" : "Allow",
        "Action" : [
          "cloudformation:CreateStackInstances",
          "cloudformation:CreateStackSet",
          "cloudformation:DeleteStackInstances",
          "cloudformation:DeleteStackSet",
          "cloudformation:ListStackInstances",
          "cloudformation:ListStackSets"
        ],
        "Resource" : [
          "arn:aws:cloudformation:${var.aws_region}:${var.aws_account_id}:stackset/*"
        ]
      }
    ]
  })
}
