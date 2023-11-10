resource "aws_organizations_organizational_unit" "infrastructure" {
  name      = "${var.organization}-ou-root-infrastructure"
  parent_id = aws_organizations_organizational_unit.org_root.id
}

resource "aws_organizations_organizational_unit" "infrastructure-env" {
  for_each  = local.set_of_environments
  name      = "${var.organization}-ou-root_infrastructure-${each.value}"
  parent_id = aws_organizations_organizational_unit.infrastructure.id
}

/*
resource "aws_organizations_account" "network-env" {
  for_each          = local.set_of_environments
  name              = "account-network-${each.value}"
  email             = "account-network-${each.value}@kowaltz.com"
  close_on_deletion = true
  parent_id         = aws_organizations_organizational_unit.shared_infrastructure-env[each.value].id
  provider = aws.account-provider-aws_root
}

resource "aws_organizations_account" "vms-env" {
  for_each          = local.set_of_environments
  name              = "account-vms-${each.value}"
  email             = "account-vms-${each.value}@kowaltz.com"
  close_on_deletion = true
  parent_id         = aws_organizations_organizational_unit.shared_infrastructure-env[each.value].id
  provider = aws.account-provider-aws_root
}
*/