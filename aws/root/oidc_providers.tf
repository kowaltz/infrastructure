resource "aws_iam_policy_attachment" "oidc_providers_github_actions_manage" {
  name       = "oidc_providers_github_actions_manage"
  roles      = [local.root_role_name]
  policy_arn = aws_iam_policy.oidc_providers_github_actions_manage.arn
}

resource "aws_iam_policy" "oidc_providers_github_actions_manage" {
  name        = "${var.organization}-iam-policy-root-oidc_providers_github_actions_manage"
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
          "iam:ListOpenIDConnectProviderTags",
          "iam:ListOpenIDConnectProviders",
          "iam:GetOpenIDConnectProvider"
        ],
        "Resource" : [
          "*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:AddClientIDToOpenIDConnectProvider",
          "iam:CreateOpenIDConnectProvider",
          "iam:DeleteOpenIDConnectProvider",
          "iam:RemoveClientIDFromOpenIDConnectProvider",
          "iam:UpdateOpenIDConnectProviderThumbprint"
        ],
        "Resource" : [
          "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
        ]
      }
    ]
  })
}


resource "aws_iam_openid_connect_provider" "github_actions" {
  depends_on = [
    aws_iam_policy.oidc_providers_github_actions_manage,
    aws_iam_policy_attachment.oidc_providers_github_actions_manage
  ]

  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}
