resource "aws_organizations_organizational_unit" "shared_infrastructure" {
  name      = "ou-shared_infrastructure"
  parent_id = aws_organizations_organizational_unit.org_root.id
}

resource "aws_organizations_organizational_unit" "shared_infrastructure-env" {
  for_each  = local.set_of_environments
  name      = "ou-shared_infrastructure-${each.value}"
  parent_id = aws_organizations_organizational_unit.shared_infrastructure.id
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