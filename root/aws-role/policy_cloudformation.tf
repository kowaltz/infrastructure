resource "aws_iam_policy_attachment" "cloudformation" {
  name       = "cloudformation"
  roles      = [local.root_role_name]
  policy_arn = aws_iam_policy.cloudformation.arn
}

resource "aws_iam_policy" "cloudformation" {
  name        = "${local.organization}-policy-root-cloudformation"
  path        = "/root/${local.organization}/"
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
          "arn:aws:iam::${var.aws_account_id}:role/AWSServiceRoleForCloudFormationStackSetsOrgAdmin"
        ]
      },
      {
        "Sid" : "ManageStackSet"
        "Effect" : "Allow",
        "Action" : [
          "cloudformation:CreateStackInstances",
          "cloudformation:CreateStackSet",
          "cloudformation:DeleteStackInstances",
          "cloudformation:DeleteStackSet",
          "cloudformation:DescribeStackInstance",
          "cloudformation:DescribeStackSet",
          "cloudformation:DescribeStackSetOperation",
          "cloudformation:ListStackInstances",
          "cloudformation:ListStackSetOperationResults",
          "cloudformation:ListStackSets",
          "cloudformation:UpdateStackSet",
          "cloudformation:UpdateStackSetInstances"
        ],
        "Resource" : [
          "arn:aws:cloudformation:${local.aws_region}:${var.aws_account_id}:stackset/${local.organization}-*",
          // Service-managed permissions
          "arn:aws:cloudformation:*::type/resource/AWS-IAM-Role",
          "arn:aws:cloudformation::*:stackset-target/${local.organization}-stackset-*"
        ]
      }
    ]
  })
}
