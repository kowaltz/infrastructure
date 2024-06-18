# Configure the AWS Provider
provider "aws" {
  region = local.aws_region
}

locals {
  config = yamldecode(file(var.path_config_yaml))

  aws_region   = local.config.aws_region
  organization = local.config.organization

  root_role_name = "${local.organization}-role-root-spacelift_default"
}

output "root_role_name" {
  value = local.root_role_name
}