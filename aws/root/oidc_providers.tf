resource "aws_iam_policy_attachment" "github_actions_oidc_providers_manage" {
  name       = "github_actions_oidc_providers_manage"
  roles      = [local.root_role_name]
  policy_arn = aws_iam_policy.github_actions_oidc_providers_manage.arn
}

resource "aws_iam_policy" "github_actions_oidc_providers_manage" {
  name        = "${var.organization}-iam-policy-root-github_actions_oidc_providers_manage"
  path        = "/root/${var.organization}/"
  description = "Policy for managing OIDC providers for GitHub actions."

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:*OpenIDConnect*"
        ],
        "Resource" : [
          "arn:aws:iam::${var.aws_account_id}:oidc-provider/*token.actions.githubusercontent.com"
        ]
      }
    ]
  })
}


resource "aws_iam_openid_connect_provider" "github_actions" {
  depends_on = [
    aws_iam_policy.github_actions_oidc_providers_manage,
    aws_iam_policy_attachment.github_actions_oidc_providers_manage
  ]

  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}
