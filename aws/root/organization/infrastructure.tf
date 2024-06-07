resource "aws_organizations_organizational_unit" "infrastructure" {
  name      = "${var.organization}-ou-root-infrastructure"
  parent_id = aws_organizations_organizational_unit.root.id
}

resource "aws_organizations_organizational_unit" "infrastructure-env" {
  for_each  = var.set_of_environments
  name      = "${var.organization}-ou-root_infrastructure-${each.value}"
  parent_id = aws_organizations_organizational_unit.infrastructure.id
}

locals {
  infrastructure_env_path = {
    for env in var.set_of_environments : env => "root_infrastructure_${env}"
  }
}