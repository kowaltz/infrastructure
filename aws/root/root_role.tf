locals {
  root_role_name      = "${var.organization}-iam-role-root-spacelift_${var.aws_oidc_enabled ? "oidc" : "default"}"
  set_of_environments = toset(["dev", "prod"])
}

data "aws_iam_role" "root_role" {
  name = local.root_role_name
}

resource "aws_iam_policy_attachment" "ou_create_org" {
  name       = "ou_create_org"
  roles      = [local.root_role_name]
  policy_arn = aws_iam_policy.ou_create_org.arn
}

resource "aws_iam_policy_attachment" "organizations_manage" {
  name       = "organizations_manage"
  roles      = [local.root_role_name]
  policy_arn = aws_iam_policy.manage_organization.arn
}