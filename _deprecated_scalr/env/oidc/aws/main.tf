# Create an AWS IAM OIDC IdP
locals {
    aws_audience = "${var.env}-idp-oidc_scalr"
}

data "tls_certificate" "scalr" {
  url = "https://scalr.io"
}

resource "aws_iam_openid_connect_provider" "env_scalr" {
  url = "https://scalr.io"

  client_id_list = [  # Also known as "audience"
    local.aws_audience,
  ]

  thumbprint_list = [data.tls_certificate.scalr.certificates[0].sha1_fingerprint]

  tags = {
    Hierarchy = "root",
    Workload = var.env,
    Environment = "NOT_APPLICABLE",
    "Resource Group" = "NOT_APPLICABLE",
    "Resource Type" = "idp",
    "Purpose" = "oidc_scalr",
  }
}

data "aws_iam_policy_document" "env" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.env_scalr.arn]
    }

    condition {
        test = "StringLike"
        variable = "scalr.io:sub"
        values = ["account:kowaltz:environment:account-environment-${var.env}:workspace:${var.env}-workspace-*"]
    }

    condition {
        test = "StringEquals"
        variable = "scalr.io:aud"
        values = [local.aws_audience]
    }
  }
}

resource "aws_iam_role" "env-role-scalr" {
  name               = "${var.env}-role-scalr"
  # path               = "/${var.env}/"
  assume_role_policy = data.aws_iam_policy_document.env.json
}