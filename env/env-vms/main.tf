# Configure the AWS Provider
provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_id_infrastructure_env_vms}:role/${var.aws_role_name}"
  }

  region = var.aws_region
}