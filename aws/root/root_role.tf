locals {
  root_role_name      = "${var.organization}-iam-role-root-spacelift_${var.aws_oidc_enabled ? "oidc" : "default"}"
  set_of_environments = toset(["dev", "prod"])
}

data "aws_iam_role" "root_role" {
  name = local.root_role_name
}