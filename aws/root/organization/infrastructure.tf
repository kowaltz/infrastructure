resource "aws_organizations_organizational_unit" "infrastructure" {
  name      = "${var.organization}-ou-infrastructure"
  parent_id = aws_organizations_organizational_unit.root.id
}

resource "aws_organizations_organizational_unit" "infrastructure_env" {
  for_each  = var.set_of_environments
  name      = "${var.organization}-ou-infrastructure_${each.value}"
  parent_id = aws_organizations_organizational_unit.infrastructure.id
}

locals {
  infrastructure_env_path = {
    for env in var.set_of_environments : env => "infrastructure_${env}"
  }
}