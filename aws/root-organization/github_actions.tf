# This Terraform file defines the infrastructure for the root organization in AWS,
# specifically for the GitHub Actions OIDC provider.
# It creates an IAM policy attachment and policy for managing EC2 VM images and building AMIs.
# The resources are created for each environment specified in the `var.set_of_environments` variable.

module "oidc_provider-github-infrastructure" {
  depends_on = [aws_iam_openid_connect_provider.github_actions]
  for_each   = var.set_of_environments
  source     = "../modules/oidc_provider-github"

  aws_account_id = var.aws_account_id
  env            = each.value
  github_repo    = "infrastructure"
}

resource "aws_iam_policy_attachment" "manage_ec2_images" {
  for_each = toset(["prod"]) # var.set_of_environments

  name       = "manage_ec2_images"
  roles      = [module.oidc_provider-github-infrastructure[each.value].role_name]
  policy_arn = aws_iam_policy.manage_ec2_images[each.value].arn
}

resource "aws_iam_policy" "manage_ec2_images" {
  for_each = toset(["prod"]) # var.set_of_environments

  name        = "${var.organization}-iam-policy-root_infrastructure_${each.value}_vms-manage_ec2_images"
  path        = "/root/${var.organization}/infrastructure/${each.value}/vms/"
  description = "Policy for managing the EC2 VM's images, and building AMIs in the infrastructure ${each.value} account."

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:AttachVolume",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CopyImage",
          "ec2:CreateImage",
          "ec2:CreateKeyPair",
          "ec2:CreateSecurityGroup",
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteKeyPair",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteSnapshot",
          "ec2:DeleteVolume",
          "ec2:DeregisterImage",
          "ec2:DescribeImageAttribute",
          "ec2:DescribeImages",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeRegions",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSnapshots",
          "ec2:DescribeSubnets",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVpcs",
          "ec2:DetachVolume",
          "ec2:GetPasswordData",
          "ec2:ModifyImageAttribute",
          "ec2:ModifyInstanceAttribute",
          "ec2:ModifySnapshotAttribute",
          "ec2:RegisterImage",
          "ec2:RunInstances",
          "ec2:StopInstances",
          "ec2:TerminateInstances"
        ],
        "Resource" : [
          "arn:aws:ec2:*:${module.aws_organizations_account[each.value].id}:*"
        ]
      }
    ]
  })
}
